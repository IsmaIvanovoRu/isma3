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
end