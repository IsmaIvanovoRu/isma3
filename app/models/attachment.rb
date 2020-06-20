class Attachment < ActiveRecord::Base
  require 'rmagick'
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :profiles
  has_and_belongs_to_many :divisions
  has_and_belongs_to_many :achievements
  
  def uploaded_file(incoming_file, gravity = "default")
    self.title = incoming_file.original_filename
    self.mime_type = incoming_file.content_type
    md5 = ::Digest::MD5.file(incoming_file.tempfile.path).hexdigest
    self.file_name = md5
    path = file_name[0..2].split('').join('/')
    %x(mkdir -p #{Rails.root.join('public', 'storage', path)})
    file_path = Rails.root.join('public', 'storage', path, self.file_name)
    copy_file(file_path, incoming_file)
    self.content = pdf2text(file_path) if self.mime_type =~ /pdf/
    if incoming_file.content_type =~ /image/
      img = Magick::Image.read(file_path).first
      img.scale!(img.columns > img.rows ? 1024 / img.columns.to_f : 1024 / img.rows.to_f) if img.rows > 1024 || img.columns > 1024
      img.write(file_path)
      %x(jpegoptim -s #{file_path}) if incoming_file.content_type =~ /jpeg/
      img.resize_to_fill!(150) if gravity == 'default'
      img.resize_to_fill!(150, 150, ::Magick::NorthGravity) if gravity == 'north'
      self.thumbnail_name = 'thumb-' + md5
      thumbnail_path = Rails.root.join('public', 'storage', path, self.thumbnail_name)
      img.write(thumbnail_path)
    end
  end
  

  def filename=(new_filename)
    write_attribute("filename", sanitize_filename(new_filename))
  end
  
  def title_sen_dot
    if %r{[.]} =~ title
      title.reverse.from((%r{[.].+} =~ title.reverse) + 1).reverse
    else
      title
    end
  end
  
  private
  def sanitize_filename(filename)
      #get only the filename, not the whole path (from IE)
      just_filename = File.basename(filename)
      #replace all non-alphanumeric, underscore or periods with underscores
      just_filename.gsub(/[^\w\.\-]/, '_')
  end
  
  def pdf2text(data)
    `pdftotext #{data} -`
  end
  
  def copy_file(file_path, temp_file)
    File.open(file_path, "wb"){|file| file.write(temp_file.read)}
  end
end
