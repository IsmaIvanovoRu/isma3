module ArticlesHelper
  def sanitize_full(text)
    Sanitize.clean(text, Sanitize::Config::RELAXED).html_safe
  end
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 255, :omission => '... ', :separator => ' ')
  end
end
