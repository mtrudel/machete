defprotocol ExMatchers.Matchable do
  @fallback_to_any true

  @spec mismatches(t, term()) :: [ExMatchers.Mismatch.t()] | nil
  def mismatches(a, b)
end
