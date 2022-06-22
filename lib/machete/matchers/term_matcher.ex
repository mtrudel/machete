defmodule Machete.TermMatcher do
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

      iex> assert "a" ~> term()
      true

      iex> assert :a ~> term()
      true

      iex> assert 1 ~> term()
      true

      iex> assert %{} ~> term()
      true

      iex> assert nil ~> term()
      true
  """
  @spec term(opts()) :: t()
  def term(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, _), do: nil
  end
end
