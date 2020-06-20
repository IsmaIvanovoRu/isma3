class Article < ActiveRecord::Base
  belongs_to :article_type
  has_many :comments
  belongs_to :user
  belongs_to :division
  has_many :groups, :through => :user
  has_many :divisions, :through => :user
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :attachments_for_articles, select: ":id, :data", class_name: "Attachment"
  validates :title, :article_type_id, :presence => true
  validates :title, :message, :length => { :maximum => 255 }
  
  def first_image_attachment
    attachments_for_articles.select {|a| a.mime_type =~ /image/}.first
  end
end
