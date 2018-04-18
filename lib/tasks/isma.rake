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
    require 'net/ldap'
    
    base_dn = "cn=#{ENV['LDAP_USER']},dc=isma,dc=ivanovo,dc=ru"
    extended_dn = "ou=people,#{base_dn}"
    unused_logins = []
# настройка подключения к серверу openldap
    ldap = Net::LDAP.new
    ldap.host = ENV['LDAP_HOST']
    ldap.auth base_dn, ENV['LDAP_PASS']
    ldap.bind
# выгрузка существующих записей
    list = ldap.search(base: extended_dn, attributes: ['uid', 'cn', 'sn', 'givenname', 'mail']) || ldap.add(dn: extended_dn, attributes: {ou: 'people', objectClass: 'organizationalUnit'})
    openldap_hash = {}
    list.each do |item|
      unless item[:uid].empty?
        openldap_hash[item[:uid]] = {}
        openldap_hash[item[:uid]][:dn] = item[:dn]
        openldap_hash[item[:uid]][:cn] = item[:cn] if item[:cn]
        openldap_hash[item[:uid]][:sn] = item[:sn] if item[:sn]
        openldap_hash[item[:uid]][:givenname] = item[:givenname] if item[:givenname]
        openldap_hash[item[:uid]][:mail] = item[:mail] if item[:mail]
      end
    end
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
      openldap_entry = openldap_hash[[login_lat]]
      if employee
        if openldap_entry
          puts 'обновляем атрибуты'
          ldap.replace_attribute(openldap_entry[:dn], :cn, employee.login) || (ldap.add_attribute openldap_entry[:dn], :cn, employee.login)
          ldap.replace_attribute(openldap_entry[:dn], :sn, employee.profile.last_name) || ldap.add_attribute(openldap_entry[:dn], :sn, employee.profile.last_name)
          ldap.replace_attribute(openldap_entry[:dn], :givenname, employee.profile.first_name) || ldap.add_attribute(openldap_entry[:dn], :givenname, employee.profile.first_name)
          ldap.replace_attribute(openldap_entry[:dn], :userPassword, row['password']) || ldap.add_attribute(openldap_entry[:dn], :userPassword, row['password'])
        else
          puts 'добавляем запись'
          mail = employee.profile.email.empty? ? 'no-reply@isma.ivanovo.ru' : employee.profile.email
          ldap.add dn: "uid=#{login_lat},#{extended_dn}", attributes: {uid: login_lat,
                                                                       cn: employee.login,
                                                                       sn: employee.profile.last_name,
                                                                       givenname: employee.profile.first_name,
                                                                       objectClass: 'inetOrgPerson',
                                                                       userPassword: row['password'],
                                                                       mail: mail}
          puts ldap.get_operation_result.code == 0 ? 'запись успешно добавлена' : "ошибка добавления записи - #{ldap.get_operation_result.message}"
        end
        unused_logins = unused_logins - [employee]
      else
        if openldap_entry
          puts 'удаляем запись'
          ldap.delete dn: openldap_entry['dn']
          puts ldap.get_operation_result.code == 0 ? 'запись успешно удалена' : "ошибка удаления записи - #{ldap.get_operation_result.message}"
        end
      end
    end
    puts unused_logins.map(&:login)
    puts "обработка списка преподавателей завершена, #{unused_logins.count} учетных записей не найдено"
  end
  
  desc 'openldap sync_students'
  task openldap_sync_students: :environment do
    require 'net/ldap'
    
    base_dn = 'cn=admin,dc=isma,dc=ivanovo,dc=ru'
    extended_dn = "ou=people,#{base_dn}"
    unused_logins = []
# настройка подключения к серверу openldap
    ldap = Net::LDAP.new
    ldap.host = '10.0.3.218'
    ldap.auth base_dn, 'admin'
    ldap.bind
# выгрузка существующих записей
    list = ldap.search(base: extended_dn, attributes: ['uid', 'cn', 'sn', 'givenname', 'mail']) || ldap.add(dn: extended_dn, attributes: {ou: 'people', objectClass: 'organizationalUnit'})
    openldap_hash = {}
    list.each do |item|
      unless item[:uid].empty?
        openldap_hash[item[:uid]] = {}
        openldap_hash[item[:uid]][:dn] = item[:dn]
        openldap_hash[item[:uid]][:cn] = item[:cn] if item[:cn]
        openldap_hash[item[:uid]][:sn] = item[:sn] if item[:sn]
        openldap_hash[item[:uid]][:givenname] = item[:givenname] if item[:givenname]
        openldap_hash[item[:uid]][:mail] = item[:mail] if item[:mail]
      end
    end  
# выгрузка списка обучающихся с сайта
    students = load_users('students')
# чтение актуального списка студентов
    students_1c = open_spreadsheet('students_1c.csv')
    unused_rows = []
# чтение списка учетных записей обучающихся
#     students_logins = open_spreadsheet('data/students_logins.csv')
    header = students_1c.row(1)
    (2..students_1c.last_row).each do |i|
      row = Hash[[header, students_1c.row(i)].transpose]
      puts "обрабатываем запись #{i} из #{students_1c.last_row - 1}"
      login = case row['speciality']
              when 'Лечебное дело'
                row['stage'].to_s == '1' ? "lech#{row['number']}" : "l#{row['number']}"
              when 'Педиатрия'
                row['stage'].to_s == '1' ? "ped#{row['number']}" : "p#{row['number']}"
              when 'Стоматология'
                row['stage'].to_s == '1' ? "stomat#{row['number']}" : "s#{row['number']}"
              else
                "ord#{row['number']}"
              end
      student = students.find_by_login(login)
      openldap_entry = openldap_hash[[login]]
      if student
        puts "студент #{student.profile.full_name}"
        if row['status'] == 'Отчислен'
          puts 'удаляем студента из группы'
          student.groups.delete(Group.find_by_name('students'))
          student.posts.each{|p| p.destroy if p.division.division_type_id == 6}
        else
          student_groups = student.groups.map(&:name)
          student.groups << Group.find_by_name('students') unless student_groups.include? 'students'
          student.groups << Group.find_by_name('writers') unless student_groups.include? 'students'
          
          divisions = student.divisions.where(division_type_id: 6)
          speciality_inflect = case row['speciality']
                                when 'Лечебное дело'
                                  'лечебного факультета'
                                when 'Педиатрия'
                                  'педиатрического факультета'
                                when 'Стоматология'
                                  'стоматологического факультета'
                                else
                                  'ординатура'
                                end
          division_1c_name = row['type'] == 'специалитет' ? "#{row['group']} группа #{row['stage']} курса #{speciality_inflect}" : "#{speciality_inflect} по специальности #{row['speciality']}, #{row['stage']} год обучения"
          if divisions.first.name != division_1c_name
            puts 'переводим студента в другую группу'
            division_new = Division.find_by_name(division_1c_name) || Division.create(name: division_1c_name)
            divisions.first.posts.where(user_id: student.id).first.update_attributes(division_id: division_new.id)
          end
        end
      else
        unused_rows.push row
      end
    end
    puts unused_rows
    puts "обработка студентов завершена, #{unused_rows.count - 1} строк не найдено"
  end
  
  private

# метод чтения csv-файла
  def open_spreadsheet(file)
    Roo::CSV.new([Rails.root, 'lib', 'tasks', 'data', file].join('/'))
  end
# метод загрузки пользователей сайта
  def load_users(group)
    User.includes(:profile).joins(:groups).where(groups: {name: group}).select(:id, :login)
  end
end