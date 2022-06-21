defmodule Machete.TruthyMatcher do
  @moduledoc """
  Defines a matcher that matches truthy values
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
  Matches against [truthy values](https://hexdocs.pm/elixir/1.12/Kernel.html#module-truthy-and-falsy-values).

  Takes no arguments

  Examples:
      
      iex> assert true ~> truthy()
      true

      iex> assert 123 ~> truthy()
      true

      iex> refute false ~> truthy()
      false

      iex> refute nil ~> truthy()
      false
  """
  @spec truthy(opts()) :: t()
  def truthy(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, nil), do: mismatch("nil is not truthy")
    def mismatches(%@for{}, false), do: mismatch("false is not truthy")
    def mismatches(%@for{}, _), do: nil
  end
end
