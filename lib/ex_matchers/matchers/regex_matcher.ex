# This one is a bit different, since regexes have a sigil but cannot be compared structurally
defimpl ExMatchers.Matchable, for: Regex do
  def matches?(%Regex{} = a, b) when is_binary(b), do: Regex.match?(a, b)
  def matches?(%Regex{}, _), do: false
end
