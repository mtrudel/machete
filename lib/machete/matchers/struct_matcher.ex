defmodule Machete.StructMatcher do
  @moduledoc """
  Defines a matcher that matches structs only on a specified list of fields
  """

  import Machete.AllMatcher
  import Machete.IsAMatcher
  import Machete.Operators
  import Machete.SupersetMatcher

  defstruct type: nil, fields: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches structs only on a specified list of fields. Structs can be tricky to match because they
  have default values for fields which are not specified at the point of creation. After creation
  these default values are otherwise indistinguishable from user-specified ones, and often get in
  the way of effective matching. This matcher provides a convenient way around this by allowing
  the user to describe both the type of struct expected as well as a set of matchers for fields
  within the struct; only the fields explicitly listed in the matcher are examined.

  Fields can be specified via a map or keyword list in a manner identical to that of
  `Kernel.struct/2`. Fields may be matched using any matcher, not just literal values.

  Examples:
      iex> assert %URI{host: "example.com", path: "/abc"} ~> struct_like(URI, %{host: "example.com"})
      true

      iex> assert %URI{host: "example.com", path: "/abc"} ~> struct_like(URI, host: "example.com")
      true

      iex> assert %URI{host: "example.com", path: "/abc"} ~> struct_like(URI, host: string())
      true

      iex> refute %URI{host: "example.com"} ~> struct_like(URI, host: "example.com", path: "/abc")
      false
  """
  @spec struct_like(struct(), Enum.t()) :: t()
  def struct_like(type, fields),
    do: struct!(__MODULE__, type: type, fields: Enum.into(fields, %{}))

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      b ~>> all([is_a(a.type), superset(a.fields)])
    end
  end
end
