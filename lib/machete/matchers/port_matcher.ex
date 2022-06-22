defmodule Machete.PortMatcher do
  @moduledoc """
  Defines a matcher that matches port values
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
  Matches against port values

  Takes no arguments

  Examples:
      
      iex> assert hd(Port.list()) ~> port()
      true

      iex> refute "a" ~> port()
      false
  """
  @spec port(opts()) :: t()
  def port(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_port(b), do: mismatch("#{inspect(b)} is not a port")
    end
  end
end
