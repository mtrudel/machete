defmodule Machete.Operators do
  @moduledoc """
  Defines implementations for the `~>` and `~>>` operators
  """

  @doc """
  Matches data on the left hand side against matcher(s) on the right hand side. Matching is
  determined by calling the `Machete.Matchable.mismatches/2` protocol function using the right
  hand side's implementation

  Examples:

      iex> 1 ~> 1
      true

      iex> 1 ~> integer()
      true

      iex> "1" ~> integer()
      false

      iex> %{a: 1, b: "abc"} ~> %{a: 1, b: string()}
      true

  Returns a boolean result indicating whether the left hand side matched against the right hand
  side
  """
  @spec term() ~> term() :: boolean()
  def a ~> b do
    a ~>> b == []
  end

  @doc """
  Returns the list of mismatches between the left and right hand side arguments, determined by 
  calling the `Machete.Matchable.mismatches/2` protocol function using the right hand side's
  implementation

  Examples:

      iex> 1 ~>> 1
      []

      iex> 1 ~>> integer()
      []

      iex> "1" ~>> integer()
      [%Machete.Mismatch{message: "\\"1\\" is not an integer", path: []}]

      iex> %{a: 1} ~>> %{a: 2}
      [%Machete.Mismatch{message: "1 is not equal to 2", path: [:a]}]

  Returns a (possibly empty) list of `Machete.Mismatch` structs
  """
  @spec term() ~>> term() :: [Machete.Mismatch.t()]
  def a ~>> b do
    Machete.Matchable.mismatches(b, a) || []
  end
end
