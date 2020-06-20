xml.urlset('xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9") do
  @articles.each do |article|
    xml.url do
      xml.loc article_url(article, protocol: 'https')
      xml.lastmod article.updated_at.to_date
    end
  end
  @divisions.each do |division|
    xml.url do
      xml.loc division_url(division, protocol: 'https')
      xml.lastmod division.updated_at.to_date
    end
  end
  @posts.each do |post|
    xml.url do
      xml.loc division_post_url(post.division, post, protocol: 'https')
      xml.lastmod post.updated_at.to_date
    end
  end
  @profiles.each do |profile|
    xml.url do
      xml.loc user_profile_url(profile.user, protocol: 'https')
      xml.lastmod profile.updated_at.to_date
    end
  end
  @attachments.each do |attachment|
    xml.url do
      xml.loc attachment_url(attachment, protocol: 'https')
      xml.lastmod attachment.updated_at.to_date
    end
  end
end
