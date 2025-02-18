defmodule Machete.UnixTimeMatcher do
  @moduledoc """
  Defines a matcher that matches integers that represent Unix time in milliseconds
  """

  import Machete.Mismatch

  defstruct exactly: nil, roughly: nil, epsilon: nil, before: nil, after: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:exactly, integer()},
          {:roughly, integer() | :now},
          {:epsilon, integer() | {integer(), integer()}},
          {:before, integer() | :now},
          {:after, integer() | :now}
        ]

  @doc """
  Matches against integers that represent Unix time values in milliseconds

  Takes the following arguments:

  * `exactly`: Requires the matched Unix time to be exactly equal to the specified Unix time
  * `roughly`: Requires the matched Unix time to be within `epsilon` seconds of the specified Unix
    time. The atom `:now` can be used to use the current time as the specified Unix time
  * `epsilon`: The bound(s) to use when determining how close (in milliseconds) the matched Unix
    time needs to be to `roughly`. Can be specified as a single integer that is used for both lower
    and upper bounds, or a tuple consisting of distinct lower and upper bounds. If not specified,
    defaults to 10_000 milliseconds
  * `before`: Requires the matched Unix time to be before or equal to the specified Unix time. The atom
    `:now` can be used to use the current time as the specified Unix time
  * `after`: Requires the matched Unix time to be after or equal to the specified Unix time. The atom `:now`
    can be used to use the current time as the specified Unix time

  Examples:

      iex> assert :os.system_time(:millisecond) ~> unix_time()
      true

      iex> assert 1681060000000 ~> unix_time(exactly: 1681060000000)
      true

      iex> assert :os.system_time(:millisecond) ~> unix_time(roughly: :now)
      true

      iex> assert 1681060000000 ~> unix_time(roughly: 1681060005000)
      true

      iex> assert 1681060000000 ~> unix_time(roughly: 1681060001000, epsilon: 1000)
      true

      iex> assert 1681060000000 ~> unix_time(roughly: 1681060001000, epsilon: {1000, 500})
      true

      iex> refute 1681060000000 ~> unix_time(roughly: 1681060001001, epsilon: 1000)
      false

      iex> refute 1681060000000 ~> unix_time(roughly: 1681060001001, epsilon: {1000, 500})
      false

      iex> assert 1681060000000 ~> unix_time(before: :now)
      true

      iex> assert 1681060000000 ~> unix_time(before: 1681090000000)
      true

      iex> assert 9991090000000 ~> unix_time(after: :now)
      true

      iex> assert 1681060000000 ~> unix_time(after: 0)
      true
  """
  @spec unix_time(opts()) :: t()
  def unix_time(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_exactly(b, a.exactly),
           nil <- matches_roughly(b, a.roughly, a.epsilon),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(b) when is_integer(b), do: nil

    defp matches_type(b),
      do: mismatch("#{safe_inspect(b)} is not an integer that represents a unix time")

    defp matches_exactly(_, nil), do: nil

    defp matches_exactly(b, exactly) do
      if b != exactly do
        mismatch("#{safe_inspect(b)} is not equal to #{safe_inspect(exactly)}")
      end
    end

    defp matches_roughly(b, :now, epsilon), do: matches_roughly(b, now(), epsilon)

    defp matches_roughly(b, roughly, epsilon) when is_integer(roughly) do
      if b < lower_bound(roughly, epsilon) or b > upper_bound(roughly, epsilon),
        do: mismatch("#{safe_inspect(b)} is not roughly equal to #{roughly}")
    end

    defp matches_roughly(_, _, _), do: nil

    defp lower_bound(roughly, nil), do: roughly - 10_000
    defp lower_bound(roughly, {lower, _upper}), do: roughly - abs(lower)
    defp lower_bound(roughly, epsilon), do: roughly - abs(epsilon)

    defp upper_bound(roughly, nil), do: roughly + 10_000
    defp upper_bound(roughly, {_lower, upper}), do: roughly + abs(upper)
    defp upper_bound(roughly, epsilon), do: roughly + abs(epsilon)

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :now), do: matches_before(b, now())

    defp matches_before(b, before) when is_integer(before) do
      if !(b < before) do
        mismatch("#{safe_inspect(b)} is not before #{safe_inspect(before)}")
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :now), do: matches_after(b, now())

    defp matches_after(b, after_var) do
      if !(b > after_var) do
        mismatch("#{safe_inspect(b)} is not after #{safe_inspect(after_var)}")
      end
    end

    defp now do
      :os.system_time(:millisecond)
    end
  end
end
