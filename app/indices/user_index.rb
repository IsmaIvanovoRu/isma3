ThinkingSphinx::Index.define :user, :with => :active_record do
  indexes profile.full_name, :as => :name
  indexes profile.phone, :as => :phone
  indexes profile.about, :as => :about
  indexes post.name, :as => :post
  indexes degree.name, :as => :degree
  indexes academic_title, :as => :academic_title
end