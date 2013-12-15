json.array!(@articles) do |article|
  json.extract! article, :title_ru, :title_en, :content_ru, :content_en, :type_id, :expire, :published, :cut_content_ru, :cut_content_en
  json.url article_url(article, format: :json)
end
