module ArticlesHelper
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 400, :omission => '... ', :separator => '. ')
  end
end
