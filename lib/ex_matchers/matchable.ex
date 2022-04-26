defprotocol ExMatchers.Matchable do
  @fallback_to_any true

  def matches?(a, b)
end
