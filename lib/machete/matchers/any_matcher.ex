defmodule Machete.AnyMatcher do
  @moduledoc """
  Defines a matcher that matches everything
  """

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
  Matches everything

  Takes no arguments

  Examples:

      iex> assert "a" ~> any()
      true

      iex> assert :a ~> any()
      true

      iex> assert 1 ~> any()
      true

      iex> assert %{} ~> any()
      true

      iex> assert nil ~> any()
      true
  """
  @spec any(opts()) :: t()
  def any(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, _), do: nil
  end
end
