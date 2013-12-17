class Article < ActiveRecord::Base
  belongs_to :article_type
  has_and_belongs_to_many :attachments
  validate :title, :content, :article_type_id, :presence => true
  
  def first_image_attachment
    attachments.select {|a| a.mime_type =~ /image/}.first
  end
end
