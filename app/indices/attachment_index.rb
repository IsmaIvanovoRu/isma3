ThinkingSphinx::Index.define :attachment, :with => :active_record do
  indexes title, content
end