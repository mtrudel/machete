defimpl ExMatchers.Matchable, for: Map do
  def matches?(%{} = a, %{} = b) do
    matching_keys?(a, b) && matching_values?(a, b)
  end

  def matches?(_, _), do: false

  defp matching_keys?(a, b), do: Map.keys(a) == Map.keys(b)

  defp matching_values?(a, b) do
    Enum.all?(b, fn {k, v} ->
      ExMatchers.Matchable.matches?(a[k], v)
    end)
  end
end
