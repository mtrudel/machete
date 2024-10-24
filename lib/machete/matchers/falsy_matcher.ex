defmodule Machete.FalsyMatcher do
  @moduledoc """
  Defines a matcher that matches falsy values
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
  Matches against [falsy values](https://hexdocs.pm/elixir/1.12/Kernel.html#module-truthy-and-falsy-values)

  Takes no arguments

  Examples:

      iex> assert false ~> falsy()
      true

      iex> assert nil ~> falsy()
      true

      iex> refute true ~> falsy()
      false
  """
  @spec falsy(opts()) :: t()
  def falsy(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, nil), do: nil
    def mismatches(%@for{}, false), do: nil
    def mismatches(%@for{}, b), do: mismatch("#{safe_inspect(b)} is not falsy")
  end
end
