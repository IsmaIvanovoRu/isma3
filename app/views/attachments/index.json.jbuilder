json.array!(@attachments) do |attachment|
  json.extract! attachment, :title, :data, :mime_type, :thumbnail, :content
  json.url attachment_url(attachment, format: :json)
end
