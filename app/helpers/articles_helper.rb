module ArticlesHelper
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 300, :omission => '... ', :separator => ' ')
  end
end
