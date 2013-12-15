module AttachmentsHelper
  def attachment_images(article)
    article.attachments.select {|a| a.mime_type =~ /image/} - [first_image(article)]
  end
  
  def attachment_noimages(article)
    article.attachments.select {|a| a.mime_type !~ /image/}
  end
  
  def attachment_name(title)
    %r{[.]} =~ title ? title.reverse.from((%r{[.].+} =~ title.reverse) + 1).reverse : title
  end
end
