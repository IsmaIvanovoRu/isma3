class Article < ActiveRecord::Base
  belongs_to :article_type
  belongs_to :user
  belongs_to :division
  has_many :groups, :through => :user
  has_many :divisions, :through => :user
  has_and_belongs_to_many :attachments
  validate :title, :content, :article_type_id, :presence => true
  
  def first_image_attachment
    attachments.select {|a| a.mime_type =~ /image/}.first
  end
end
