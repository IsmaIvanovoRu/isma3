json.array!(@groups) do |group|
  json.extract! group, :name, :administrator, :editor, :viewer
  json.url group_url(group, format: :json)
end
