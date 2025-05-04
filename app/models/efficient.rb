class Efficient < ActiveRecord::Base
  belongs_to :criterium
  belongs_to :user
  has_one :profile, through: :user
  has_many :divisions, through: :user
  has_many :posts, through: :user
  has_and_belongs_to_many :attachments
end
