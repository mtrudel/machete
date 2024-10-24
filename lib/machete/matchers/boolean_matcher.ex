defmodule Machete.BooleanMatcher do
  @moduledoc """
  Defines a matcher that matches boolean values
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
  Matches against boolean values

  Takes no arguments

  Examples:

      iex> assert true ~> boolean()
      true

      iex> assert true ~> boolean()
      true

      iex> refute 1 ~> boolean()
      false

      iex> refute nil ~> boolean()
      false
  """
  @spec boolean(opts()) :: t()
  def boolean(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_boolean(b), do: mismatch("#{safe_inspect(b)} is not a boolean")
    end
  end
end
