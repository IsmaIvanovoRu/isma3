class Article < ActiveRecord::Base
  belongs_to :article_type
  has_and_belongs_to_many :attachments
  validate :title, :content, :article_type_id, :presence => true
end
