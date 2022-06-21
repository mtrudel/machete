defmodule Machete.StringMatcher do
  @moduledoc """
  Defines a matcher that matches string values
  """

  import Machete.Mismatch

  defstruct empty: nil,
            length: nil,
            min: nil,
            max: nil,
            matches: nil,
            alphabetic: nil,
            lowercase: nil,
            uppercase: nil,
            alphanumeric: nil,
            numeric: nil,
            hexadecimal: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:empty, boolean()},
          {:length, non_neg_integer()},
          {:min, non_neg_integer()},
          {:max, non_neg_integer()},
          {:matches, Regex.t()},
          {:alphabetic, boolean()},
          {:lowercase, boolean()},
          {:uppercase, boolean()},
          {:alphanumeric, boolean()},
          {:numeric, boolean()},
          {:hexdecimal, boolean()}
        ]

  @doc """
  Matches against string values

  Takes the following arguments:

  * `empty`: When `true`, requires the matched string be empty. When false, requires the matched
    string to be non-empty
  * `length`: Requires the matched string to be exactly the specified length
  * `min`: Requires the matched string to be greater than or equal to the specified length
  * `max`: Requires the matched string to be less than or equal to the specified length
  * `matches`: Requires the matched string to match the specified regex
  * `alphabetic`: When `true`, requires the matched string to consist of alphabetic characters
  * `lowercase`: When `true`, requires the matched string to consist of lowercase characters
  * `uppercase`: When `true`, requires the matched string to consist of uppercase characters
  * `alphanumeric`: When `true`, requires the matched string to consist of alphanumeric characters
  * `numeric`: When `true`, requires the matched string to consist of numeric characters
  * `hexadecimal`: When `true`, requires the matched string to consist of hexadecimal characters

  Examples:

      iex> assert "" ~> string()
      true

      iex> assert "abc" ~> string(length: 3)
      true

      iex> assert "abc" ~> string(min: 3)
      true

      iex> assert "abc" ~> string(max: 3)
      true

      iex> assert "" ~> string(empty: true)
      true

      iex> assert "abc" ~> string(empty: false)
      true

      iex> assert "abc" ~> string(matches: ~r/abc/)
      true

      iex> assert "abc" ~> string(alphabetic: true)
      true

      iex> assert "123" ~> string(alphabetic: false)
      true

      iex> assert "abc" ~> string(lowercase: true)
      true

      iex> assert "ABC" ~> string(lowercase: false)
      true

      iex> assert "ABC" ~> string(uppercase: true)
      true

      iex> assert "abc" ~> string(uppercase: false)
      true

      iex> assert "abc123" ~> string(alphanumeric: true)
      true

      iex> assert "$" ~> string(alphanumeric: false)
      true

      iex> assert "123" ~> string(numeric: true)
      true

      iex> assert "abc" ~> string(numeric: false)
      true

      iex> assert "deadbeef0123" ~> string(hexadecimal: true)
      true

      iex> assert "ghi" ~> string(hexadecimal: false)
      true
  """
  @spec string(opts()) :: t()
  def string(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_empty(b, a.empty),
           nil <- matches_length(b, a.length),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max),
           nil <- matches_regex(b, a.matches),
           nil <- matches_alphabetic(b, a.alphabetic),
           nil <- matches_lowercase(b, a.lowercase),
           nil <- matches_uppercase(b, a.uppercase),
           nil <- matches_alphanumeric(b, a.alphanumeric),
           nil <- matches_numeric(b, a.numeric),
           nil <- matches_hexadecimal(b, a.hexadecimal) do
      end
    end

    defp matches_type(b) when is_binary(b), do: nil
    defp matches_type(b), do: mismatch("#{inspect(b)} is not a string")

    defp matches_empty("" = b, false), do: mismatch("#{inspect(b)} is empty")
    defp matches_empty(b, true) when b != "", do: mismatch("#{inspect(b)} is not empty")
    defp matches_empty(_, _), do: nil

    defp matches_length(_, nil), do: nil

    defp matches_length(b, length) do
      unless String.length(b) == length do
        mismatch("#{inspect(b)} is not exactly #{length} characters")
      end
    end

    defp matches_min(_, nil), do: nil

    defp matches_min(b, length) do
      unless String.length(b) >= length do
        mismatch("#{inspect(b)} is less than #{length} characters")
      end
    end

    defp matches_max(_, nil), do: nil

    defp matches_max(b, length) do
      unless String.length(b) <= length do
        mismatch("#{inspect(b)} is more than #{length} characters")
      end
    end

    defp matches_regex(_, nil), do: nil

    defp matches_regex(b, regex) do
      unless b =~ regex do
        mismatch("#{inspect(b)} does not match #{inspect(regex)}")
      end
    end

    for {name, regex} <- [
          {"alphabetic", "^[[:alpha:]]+$"},
          {"lowercase", "^[[:lower:]]+$"},
          {"uppercase", "^[[:upper:]]+$"},
          {"alphanumeric", "^[[:alnum:]]+$"},
          {"numeric", "^[[:digit:]]+$"},
          {"hexadecimal", "^[[:xdigit:]]+$"}
        ] do
      fn_name = String.to_atom("matches_#{name}")

      def unquote(fn_name)(_, nil), do: nil

      def unquote(fn_name)(b, false) do
        if b =~ Regex.compile!(unquote(regex)) do
          mismatch("#{inspect(b)} is #{unquote(name)}")
        end
      end

      def unquote(fn_name)(b, true) do
        unless b =~ Regex.compile!(unquote(regex)) do
          mismatch("#{inspect(b)} is not #{unquote(name)}")
        end
      end
    end
  end
end
