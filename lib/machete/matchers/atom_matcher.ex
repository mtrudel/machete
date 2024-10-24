defmodule Machete.AtomMatcher do
  @moduledoc """
  Defines a matcher that matches atom values
  """

  import Machete.Mismatch

  defstruct []

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: []

  @doc """
  Matches against atom values

  Takes no arguments

  Examples:
      
      iex> assert :a ~> atom()
      true

      iex> refute "a" ~> atom()
      false
  """
  @spec atom(opts()) :: t()
  def atom(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_atom(b), do: mismatch("#{safe_inspect(b)} is not an atom")
    end
  end
end
