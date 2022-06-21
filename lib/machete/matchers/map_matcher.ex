defmodule Machete.MapMatcher do
  @moduledoc """
  Defines a matcher that matches maps
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
  Matches against map values

  Takes no arguments

  Examples:

      iex> assert %{} ~> map()
      true
  """
  @spec map(opts()) :: t()
  def map(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when is_map(b), do: nil
    def mismatches(%@for{}, b), do: mismatch("#{inspect(b)} is not a map")
  end
end
