defprotocol Machete.Matchable do
  @moduledoc """
  Defines a protocol to determine how a given term may match against a type. The
  `Machete.Matchable` protocol is central to the Machete library, and conformance to it is
  necessary for any type to be used on the right hand side of a `~>` match
  """
  @fallback_to_any true

  @doc """
  Examines the value of the passed term and returns the way(s) in which it does not
  conform to the base type instance's requirements. If there are no such mismatches (that is, if
  the passed term 'matches' against the base type instance), implementations of this protocol may
  return an empty list or `nil`; they are semantically equivalent
  """
  @spec mismatches(t, term()) :: [Machete.Mismatch.t()] | nil
  def mismatches(a, b)
end
