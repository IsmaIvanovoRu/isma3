namespace :isma do
  desc "Convert attachments from db to filesystem"
  task convert_attachments: :environment do
    counter = 0
    Attachment.find_each(batch_size: 20) do |a|
      counter += 1
      # copy tempfile from db to directory
      File.open(Rails.root.join('public', 'storage', 'tmp'), "wb"){|file| file.write(a.data)}
      
      # optimization of jpeg files
      %x(jpegoptim -s #{Rails.root.join('public', 'storage', 'tmp')}) if a.mime_type =~ /jpeg/
      
      # calculate filename for file
      file_name = ::Digest::MD5.file(Rails.root.join('public', 'storage', 'tmp')).hexdigest
      
      # create intermediate file path
      path = file_name[0..2].split('').join('/')
      
      # make directory for file
      %x(mkdir -p #{Rails.root.join('public', 'storage', path)})
      
      # move tempfile to file
      File.rename(Rails.root.join('public', 'storage', 'tmp'), Rails.root.join('public', 'storage', path, file_name))
      
      # update file_name in db
      a.update_attributes(file_name: file_name)
      
      # check thumbnail
      if a.thumbnail
        
        # copy tempthumbnail to directory
        File.open(Rails.root.join('public', 'storage', 'tmp'), "wb"){|file| file.write(a.thumbnail)}
        
        # optimization of jpeg thumbnail
        %x(jpegoptim -s #{Rails.root.join('public', 'storage', 'tmp')}) if a.mime_type =~ /jpeg/
        
        # create thumbnail_name from file_name
        thumbnail_name = 'thumb-' + file_name
        
        # move tempthumbnail to thumbnail
        File.rename(Rails.root.join('public', 'storage', 'tmp'), Rails.root.join('public', 'storage', path, thumbnail_name))
        
        # update thumbnail_name in db
        a.update_attributes(thumbnail_name: thumbnail_name)
      end
      puts counter
    end
  end
  
  desc "Export employees"
  task export_employees: :environment do
    posts = Post.includes(:division, :profile, :degree, :academic_title).order(:division_id)
    data = posts.map{|p| [p.division.name, p.name, p.profile.full_name, (p.degree.name if p.degree), (p.academic_title.name if p.academic_title), p.profile.discipline, p.profile.qualification, p.profile.development, p.profile.general_experience, p.profile.special_experience, p.division.address, p.division.latitude, p.division.longitude, p.division.email, p.division.url, p.phone]}
    File.open('employees.csv', 'w') do |f|
      data.each do |row|
        f.write("#{row.join(";").gsub(/\n/, "")}\n")
      end
    end
  end
  
  desc 'openldap sync_employees'
  task openldap_sync_employees: :environment do
    base_dn = "dc=isma,dc=ivanovo,dc=ru"
    extended_dn = "ou=people,#{base_dn}"
    ldap = ldap_create(base_dn)
    ldap.bind
    unused_logins = []
# выгрузка существующих записей
    list = ldap_search(ldap, extended_dn)
    openldap_hash = openldap_hash_create(list)
# выгрузка списка сотрудников с сайта
    employees = load_users('employees')
# чтение списка учетных записей сотрудников
    employees_logins = open_spreadsheet('employees_logins.csv')
    unused_logins = employees
    header = employees_logins.row(1)
    (2..employees_logins.last_row).each do |i|
      row = Hash[[header, employees_logins.row(i)].transpose]
      puts "обрабатываем #{row['login']} - запись #{i} из #{employees_logins.last_row - 1}"
      employee = employees.find_by_login(row['login'])
      login_lat = Translit.convert(row['login'])
      openldap_entry = openldap_hash[login_lat]
      if employee
        if openldap_entry
          puts 'обновляем атрибуты'
          ldap.replace_attribute(openldap_entry[:dn], :cn, employee.login) || (ldap.add_attribute openldap_entry[:dn], :cn, employee.login)
          ldap.replace_attribute(openldap_entry[:dn], :sn, employee.profile.last_name) || ldap.add_attribute(openldap_entry[:dn], :sn, employee.profile.last_name)
          ldap.replace_attribute(openldap_entry[:dn], :givenname, employee.profile.first_name) || ldap.add_attribute(openldap_entry[:dn], :givenname, employee.profile.first_name)
          ldap.replace_attribute(openldap_entry[:dn], :userPassword, row['password']) || ldap.add_attribute(openldap_entry[:dn], :userPassword, row['password'])
          ldap.replace_attribute(openldap_entry[:dn], :objectClass, 'inetOrgPerson') || ldap.add_attribute(openldap_entry[:dn], :objectClass, 'inetOrgPerson')
          ldap.replace_attribute(openldap_entry[:dn], :employeeType, 'employee') || ldap.add_attribute(openldap_entry[:dn], :employeeType, 'employee')
        else
          puts 'добавляем запись'
          mail = employee.profile.email.empty? ? 'no-reply@isma.ivanovo.ru' : employee.profile.email
          ldap.add dn: "uid=#{login_lat},#{extended_dn}", attributes: {uid: login_lat,
                                                                       cn: employee.login,
                                                                       sn: employee.profile.last_name,
                                                                       givenname: employee.profile.first_name,
                                                                       objectClass: 'inetOrgPerson',
                                                                       employeeType: 'employee',
                                                                       userPassword: row['password'],
                                                                       mail: mail}
          puts ldap.get_operation_result.code == 0 ? 'запись успешно добавлена' : "ошибка добавления записи - #{ldap.get_operation_result.message}"
        end
        unused_logins = unused_logins - [employee]
      else
        if openldap_entry
          puts 'удаляем запись'
          ldap.delete dn: openldap_entry[:dn]
          puts ldap.get_operation_result.code == 0 ? 'запись успешно удалена' : "ошибка удаления записи - #{ldap.get_operation_result.message}"
        end
      end
    end
    puts unused_logins.map(&:login)
    puts "обработка списка преподавателей завершена, #{unused_logins.count} учетных записей не найдено"
  end
  
  desc 'openldap sync_students'
  task openldap_sync_students: :environment do
    base_dn = "dc=isma,dc=ivanovo,dc=ru"
    extended_dn = "ou=people,#{base_dn}"
    group_of_names = {}
    ldap = ldap_create(base_dn)
    ldap.bind
# выгрузка существующих записей
    list = ldap_search(ldap, extended_dn)
    openldap_hash = openldap_hash_create(list)
# выгрузка списка обучающихся с сайта
    students = load_users('students')
# чтение актуального списка студентов
    students_1c = open_spreadsheet('students_1c.csv') if file_exist?('students_1c.csv')
    unused_rows = []
# чтение списка учетных записей обучающихся
    students_logins = open_spreadsheet('students_logins.csv')
    if students_1c
      header = students_1c.row(1)
      (2..students_1c.last_row).each do |i|
        row = Hash[[header, students_1c.row(i)].transpose]
        puts "обрабатываем запись #{i} из #{students_1c.last_row - 1}"
        logins = student_login(row)
        student = nil
        openldap_entry = nil
        logins.each do |login|
          student ||= students.find_by_login(login)
          openldap_entry ||= openldap_hash[login]
        end
        if student
          if row['Состояние'] != 'Является студентом'
            puts "удаляем студента #{student.profile.full_name} из группы"
            student.groups.delete(Group.find_by_name('students'))
            student.posts.each{|p| p.destroy if p.division.division_type_id == 6} if student.posts
          else
            student_groups = student.groups.map(&:name)
            student.groups << Group.find_by_name('students') unless student_groups.include? 'students'
            student.groups << Group.find_by_name('writers') unless student_groups.include? 'writers'
            
            divisions = student.divisions.where(division_type_id: 6)
            speciality_inflect = case row['Направление (специальность)']
                                  when 'Лечебное дело'
                                    'лечебного факультета'
                                  when 'Педиатрия'
                                    'педиатрического факультета'
                                  when 'Стоматология'
                                    'стоматологического факультета'
                                  else
                                    'ординатура'
                                  end
            division_1c_name = row['Представление учебного плана'].match('Специалист') ? "#{row['Группа']} группа #{row['Курс']} курса #{speciality_inflect}" : "#{speciality_inflect} по специальности #{row['Направление (специальность)']}, #{row['Курс']} год обучения"
            unless divisions.map(&:name).include?(division_1c_name)
              puts "переводим студента #{student.profile.full_name} в другую группу"
              division_new = Division.find_by_name(division_1c_name) || Division.create(name: division_1c_name)
              divisions.first.posts.where(user_id: student.id).first.update_attributes(division_id: division_new.id)
            end
            puts "добавляем студента в группу ldap"
            group_of_names[division_1c_name] ||= []
            group_of_names[division_1c_name].push student.login
          end
        else
          unused_rows.push row
        end
      end
      puts 'Удаляем пустые группы'
      divisions = Division.select(:id, :division_type_id).where(division_type_id: 6).select{|d| d.posts.count == 0}
      puts "Будет удалено групп: #{divisions.count}"
      divisions.each{|d| d.destroy}
    end
    
    # чтение списка учетных записей студентов
    students = load_users('students')
    unused_logins = students
    header = students_logins.row(1)
    (2..students_logins.last_row).each do |i|
      row = Hash[[header, students_logins.row(i)].transpose]
      puts "обрабатываем #{row['login']} - запись #{i} из #{students_logins.last_row - 1}"
      student = students.find_by_login(row['login'])
      openldap_entry = openldap_hash[row['login']]
      if student
        if openldap_entry
          puts 'обновляем атрибуты'
          ldap.replace_attribute(openldap_entry[:dn], :cn, student.login) || (ldap.add_attribute openldap_entry[:dn], :cn, student.login)
          ldap.replace_attribute(openldap_entry[:dn], :sn, student.profile.last_name) || ldap.add_attribute(openldap_entry[:dn], :sn, student.profile.last_name)
          ldap.replace_attribute(openldap_entry[:dn], :givenname, student.profile.first_name) || ldap.add_attribute(openldap_entry[:dn], :givenname, student.profile.first_name)
          ldap.replace_attribute(openldap_entry[:dn], :userPassword, row['password']) || ldap.add_attribute(openldap_entry[:dn], :userPassword, row['password'])
          ldap.replace_attribute(openldap_entry[:dn], :objectClass, 'inetOrgPerson') || ldap.add_attribute(openldap_entry[:dn], :objectClass, 'inetOrgPerson')
          ldap.replace_attribute(openldap_entry[:dn], :employeeType, 'student') || ldap.add_attribute(openldap_entry[:dn], :employeeType, 'student')
        else
          puts 'добавляем запись'
          mail = student.profile.email.empty? ? 'no-reply@isma.ivanovo.ru' : student.profile.email
          ldap.add dn: "uid=#{row['login']},#{extended_dn}", attributes: {uid: row['login'],
                                                                       cn: student.login,
                                                                       sn: student.profile.last_name,
                                                                       givenname: student.profile.first_name,
                                                                       objectClass: 'inetOrgPerson',
                                                                       employeeType: 'student',
                                                                       userPassword: row['password'],
                                                                       mail: mail}
          puts ldap.get_operation_result.code == 0 ? 'запись успешно добавлена' : "ошибка добавления записи - #{ldap.get_operation_result.message}"
        end
        unused_logins = unused_logins - [student]
      else
        if openldap_entry
          puts 'удаляем запись'
          ldap.delete dn: openldap_entry[:dn]
          puts ldap.get_operation_result.code == 0 ? 'запись успешно удалена' : "ошибка удаления записи - #{ldap.get_operation_result.message}"
        end
      end
    end
    puts unused_logins.map(&:login)
    puts "обработка списка студентов завершена, учетных записей не найдено: #{unused_logins.count} "
    puts unused_rows
    puts "обработка студентов завершена, #{unused_rows.count - 1} строк не найдено"
    
    puts group_of_names
    # обрабатываем группы ldap
    group_of_names.each do |cn, members|
      ldap.delete(dn: "cn=#{cn},ou=groups,#{base_dn}")
      a = []
      members.each do |member|
        a.push "uid=#{member},#{extended_dn}"
      end
      ldap.add(dn: "cn=#{cn},ou=groups,#{base_dn}", attributes: {cn: cn,
                                                                 objectClass: 'groupOfNames',
                                                                 member: a})
    end
  end
  
  desc 'clear openldap db'
  task openldap_clear: :environment do
    
    base_dn = "dc=isma,dc=ivanovo,dc=ru"
    extended_dn = "ou=people,#{base_dn}"
    ldap = ldap_create(base_dn)
    ldap.bind
# выгрузка существующих записей
    list = ldap.search(base: extended_dn, attributes: ['uid', 'cn', 'sn', 'givenname', 'mail'])
    list.each do |item|
      unless item[:uid].empty?
        ldap.delete dn: item[:dn].first
      end
    end
    list = ldap.search(base: "ou=groups,dc=isma,dc=ivanovo,dc=ru")
    list.each do |item|
      ldap.delete dn: item[:dn].first
    end
  end
  
  private

# метод чтения csv-файла
  def open_spreadsheet(file)
    Roo::CSV.new([Rails.root, 'lib', 'tasks', 'data', file].join('/'))
  end
  
  def file_exist?(file)
    File.exist?([Rails.root, 'lib', 'tasks', 'data', file].join('/'))
  end

# метод загрузки пользователей сайта
  def load_users(group)
    User.includes(:profile).joins(:groups).where(groups: {name: group}).select(:id, :login)
  end
  
  def ldap_create(dn)
    require 'net/ldap'
        
# настройка подключения к серверу openldap
    ldap = Net::LDAP.new
    ldap.host = ENV['LDAP_HOST']
    ldap.auth "cn=#{ENV['LDAP_USER']},#{dn}", ENV['LDAP_PASS']
    return ldap
  end
  
  def ldap_search(ldap, dn)
    if ldap.search(base: dn, attributes: ['uid'])
      list = ldap.search(base: dn, attributes: ['uid', 'cn', 'sn', 'givenname', 'mail', 'employeetype'])
    else
      ldap.add(dn: dn, attributes: {ou: 'people', objectClass: 'organizationalUnit'})
      list = ldap.search(base: dn, attributes: ['uid', 'cn', 'sn', 'givenname', 'mail', 'employeetype'])
    end
    return list
  end
  
  def openldap_hash_create(list)
    openldap_hash = {}
    list.each do |item|
      unless item[:uid].empty?
        uid = item[:uid].first
        openldap_hash[uid] = {}
        openldap_hash[uid][:dn] = item[:dn].first
        openldap_hash[uid][:cn] = item[:cn].first if item[:cn]
        openldap_hash[uid][:sn] = item[:sn].first if item[:sn]
        openldap_hash[uid][:givenname] = item[:givenname].first if item[:givenname]
        openldap_hash[uid][:mail] = item[:mail].first if item[:mail]
        openldap_hash[uid][:employee_type] = item[:employeeType] if item[:employeeType]
      end
    end
    return openldap_hash
  end
  
  def student_login(row)
    case row['Направление (специальность)']
    when 'Лечебное дело'
      ["lech#{row['Зачетная книга']}", "l#{row['Зачетная книга']}"]
    when 'Педиатрия'
      ["ped#{row['Зачетная книга']}", "p#{row['Зачетная книга']}"]
    when 'Стоматология'
      ["stomat#{row['Зачетная книга']}", "s#{row['Зачетная книга']}"]
    else
      []
    end
  end
end
