atom_feed(language: 'ru-RU') do |feed|
  feed.title "ISMA"
  latest_article = @articles.last
  feed.updated(latest_article.updated_at)
  @articles.each do |article|
    feed.entry(article) do |entry|
      entry.title article.title
      entry.content sanitize_full(autosub_details article.content), type: 'html'
      entry.author do |author|
	author.name article.division_id.nil? ? (article.user && article.user.profile ? article.user.profile.full_name : '') : (@division == article.division ? '' : article.division.name)
      end
    end
  end
end