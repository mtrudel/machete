defmodule ExMatchers do
  defmacro __using__(_opts) do
    quote do
      # Bring in ~> operator  
      import ExMatchers

      # Bring in matcher builders
      import ExMatchers.AnyMatcher
      import ExMatchers.BooleanMatcher
      import ExMatchers.DateMatcher
      import ExMatchers.DateTimeMatcher
      import ExMatchers.FloatMatcher
      import ExMatchers.IntegerMatcher
      import ExMatchers.ISO8601DateTimeMatcher
      import ExMatchers.NaiveDateTimeMatcher
      import ExMatchers.StringMatcher
      import ExMatchers.TimeMatcher
    end
  end

  def a ~> b do
    ExMatchers.Matchable.mismatches(b, a) == []
  end
end
