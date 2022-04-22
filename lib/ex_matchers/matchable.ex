defprotocol ExMatchers.Matchable do
  @fallback_to_any true

  def matches?(a, b)
end

defimpl ExMatchers.Matchable, for: Any do
  def matches?(a, b), do: a === b
end
