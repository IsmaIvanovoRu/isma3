json.array!(@menus) do |menu|
  json.extract! menu, :title, :path, :weigth
  json.url menu_url(menu, format: :json)
end
