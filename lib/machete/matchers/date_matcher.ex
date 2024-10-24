defmodule Machete.DateMatcher do
  @moduledoc """
  Defines a matcher that matches Date values
  """

  import Machete.Mismatch

  defstruct exactly: nil, roughly: nil, before: nil, after: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:exactly, Date.t() | :today},
          {:roughly, Date.t() | :today},
          {:before, Date.t() | :today},
          {:after, Date.t() | :today}
        ]

  @doc """
  Matches against Date values

  Takes the following arguments:

  * `exactly`: Requires the matched Date to be exactly equal to the specified Date. The atom `:today` can
    be used to use today as the specified Date
  * `roughly`: Requires the matched Date to be within +/- 1 day of the specified Date. The atom
    `:today` can be used to use today as the specified Date
  * `before`: Requires the matched Date to be before or equal to the specified Date. The atom
    `:today` can be used to use today as the specified Date
  * `after`: Requires the matched Date to be after or equal to the specified Date. The atom
    `:today` can be used to use today as the specified Date

  Examples:

      iex> assert Date.utc_today() ~> date()
      true

      iex> assert Date.utc_today() ~> date(exactly: :today)
      true

      iex> assert ~D[2020-01-01] ~> date(exactly: ~D[2020-01-01])
      true

      iex> assert Date.utc_today() ~> date(roughly: :today)
      true

      iex> assert ~D[2020-01-01] ~> date(roughly: ~D[2020-01-02])
      true

      iex> assert ~D[2020-01-01] ~> date(before: :today)
      true

      iex> assert ~D[2020-01-01] ~> date(before: ~D[3000-01-01])
      true

      iex> assert ~D[3000-01-01] ~> date(after: :today)
      true

      iex> assert ~D[3000-01-01] ~> date(after: ~D[2020-01-01])
      true
  """
  @spec date(opts()) :: t()
  def date(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_exactly(b, a.exactly),
           nil <- matches_roughly(b, a.roughly),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%Date{}), do: nil
    defp matches_type(b), do: mismatch("#{safe_inspect(b)} is not a Date")

    defp matches_exactly(_, nil), do: nil
    defp matches_exactly(b, :today), do: matches_exactly(b, Date.utc_today())

    defp matches_exactly(b, exactly) do
      if Date.diff(b, exactly) != 0,
        do: mismatch("#{safe_inspect(b)} is not equal to #{safe_inspect(exactly)}")
    end

    defp matches_roughly(_, nil), do: nil
    defp matches_roughly(b, :today), do: matches_roughly(b, Date.utc_today())

    defp matches_roughly(b, roughly) do
      if Date.diff(b, roughly) not in -1..1 do
        mismatch("#{safe_inspect(b)} is not within 1 day of #{safe_inspect(roughly)}")
      end
    end

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :today), do: matches_before(b, Date.utc_today())

    defp matches_before(b, before) do
      if Date.compare(b, before) != :lt do
        mismatch("#{safe_inspect(b)} is not before #{safe_inspect(before)}")
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :today), do: matches_after(b, Date.utc_today())

    defp matches_after(b, after_var) do
      if Date.compare(b, after_var) != :gt do
        mismatch("#{safe_inspect(b)} is not after #{safe_inspect(after_var)}")
      end
    end
  end
end
