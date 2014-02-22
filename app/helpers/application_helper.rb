module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text).html_safe
  end
  
  def sanitize_full(text)
    Sanitize.clean(text, Sanitize::Config::RELAXED).html_safe
  end
    
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 300, :omission => '... ', :separator => ' ')
  end
  
  def first_letter_upcase(string)
    string[0] = string[0].mb_chars.upcase
    return string
  end

  def autosub_details(text)
    @details_hash.each{|k, v| text.gsub!("&amp;[#{k}]", v.to_s)} if text.include? "&amp;["
    text
  end
end
