# credo:disable-for-this-file Credo.Check.Readability.PredicateFunctionNames
defmodule Machete.IsAMatcher do
  @moduledoc """
  Defines a matcher that matches againt a type of struct
  """

  import Machete.Mismatch

  defstruct type: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches against a type of struct. Similar to `Kernel.struct/2`, the argument may be a module name
  or a struct instance. In both cases, the match is concerned solely with type equivalence.

  Examples:

      iex> assert %URI{} ~> is_a(URI)
      true

      iex> assert %URI{} ~> is_a(%URI{})
      true

      iex> refute %URI{} ~> is_a(DateTime)
      false
  """
  @spec is_a(module() | struct()) :: t()
  def is_a(%type{}), do: struct!(__MODULE__, type: type)
  def is_a(type), do: struct!(__MODULE__, type: type)

  defimpl Machete.Matchable do
    def mismatches(%@for{type: type}, %type{}), do: []

    def mismatches(%@for{type: type}, b),
      do: mismatch("#{safe_inspect(b)} is not a #{safe_inspect(type)}")
  end
end
