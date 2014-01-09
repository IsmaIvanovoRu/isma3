ThinkingSphinx::Index.define :profile, :with => :active_record do
  indexes first_name, middle_name, last_name, about
end