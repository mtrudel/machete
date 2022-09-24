defprotocol Machete.Matchable do
  @moduledoc """
  Defines a protocol to determine how a given term may match against a type. The
  `Machete.Matchable` protocol is central to the Machete library, and conformance to it is
  necessary for any type to be used on the right hand side of a `~>` match
  """
  @fallback_to_any true

  @doc """
  Examines the value of the passed term and returns the way(s) in which it does not conform to the
  base type instance's requirements, expressed as a list of `Machete.Mismatch` structs. If there
  are no such mismatches (that is, if the passed term 'matches' against the base type instance),
  implementations of this protocol may return an empty list or `nil`; they are semantically
  equivalent and are both allowed for ease of implementation. Implementors of this protocol may be interested in the `Machete.Mismatch.mismatch/2`
  function to easily create mismatches

  Note that the argument order to this function is the opposite of that for the `~>` and `~>>`
  operators; conformance to this protocol is a property of the match, and not the term being
  matched
  """
  @spec mismatches(t, term()) :: [Machete.Mismatch.t()] | nil
  def mismatches(a, b)
end
