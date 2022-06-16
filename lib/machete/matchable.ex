defprotocol Machete.Matchable do
  @fallback_to_any true

  @spec mismatches(t, term()) :: [Machete.Mismatch.t()] | nil
  def mismatches(a, b)
end
