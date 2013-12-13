class ArticleType < ActiveRecord::Base
  has_many :articles
  validate :name, :presence => true
end
