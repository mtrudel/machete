defmodule Machete.ReferenceMatcher do
  @moduledoc """
  Defines a matcher that matches reference values
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
  Matches against reference values

  Takes no arguments

  Examples:

      iex> assert make_ref() ~> reference()
      true

      iex> refute "a" ~> reference()
      false
  """
  @spec reference(opts()) :: t()
  def reference(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_reference(b), do: mismatch("#{safe_inspect(b)} is not a reference")
    end
  end
end
