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
end