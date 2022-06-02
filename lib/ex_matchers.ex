defmodule ExMatchers do
  def a ~> b do
    mismatches = ExMatchers.Matchable.mismatches(b, a)
    mismatches == []
  end

  # Matchers to work with intrinsic types
  defdelegate boolean, to: ExMatchers.BooleanMatcher, as: :new
  defdelegate integer, to: ExMatchers.IntegerMatcher, as: :new
  defdelegate float, to: ExMatchers.FloatMatcher, as: :new
  defdelegate string, to: ExMatchers.StringMatcher, as: :new

  # Matchers to work with standard library types
  defdelegate naive_datetime, to: ExMatchers.NaiveDateTimeMatcher, as: :new
  defdelegate naive_datetime(opts), to: ExMatchers.NaiveDateTimeMatcher, as: :new
  defdelegate datetime, to: ExMatchers.DateTimeMatcher, as: :new
  defdelegate datetime(opts), to: ExMatchers.DateTimeMatcher, as: :new
  defdelegate date, to: ExMatchers.DateMatcher, as: :new
  defdelegate time, to: ExMatchers.TimeMatcher, as: :new
  defdelegate time(opts), to: ExMatchers.TimeMatcher, as: :new

  # Matchers to work with various other types
  defdelegate any, to: ExMatchers.AnyMatcher, as: :new
  defdelegate iso8601_datetime, to: ExMatchers.ISO8601DateTimeMatcher, as: :new
  defdelegate iso8601_datetime(opts), to: ExMatchers.ISO8601DateTimeMatcher, as: :new

  # TODO - add map, list, tuple matchers that allow for parametrized matching ('exactly', 'covering', any_order', etc)
end
