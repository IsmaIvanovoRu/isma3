module ArticlesHelper
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 250, :omission => '... ', :separator => '. ')
  end
end
