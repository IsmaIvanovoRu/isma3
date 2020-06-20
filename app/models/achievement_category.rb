class AchievementCategory < ActiveRecord::Base
	has_many :achievements

	validates :name, presence: true
end
