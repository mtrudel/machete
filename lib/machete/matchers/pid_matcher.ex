defmodule Machete.PIDMatcher do
  @moduledoc """
  Defines a matcher that matches PID values
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
  Matches against PID values

  Takes no arguments

  Examples:

      iex> assert self() ~> pid()
      true

      iex> refute "a" ~> pid()
      false
  """
  @spec pid(opts()) :: t()
  def pid(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_pid(b), do: mismatch("#{safe_inspect(b)} is not a PID")
    end
  end
end
