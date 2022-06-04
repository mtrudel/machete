defmodule ExMatchers do
  defmacro __using__(_opts) do
    quote do
      # Take ExUnit's builtin assert and refute macros out of scope 
      # (we'll call to them explicitly as a fallback in ExMatchers.Assertions)
      import ExUnit.Assertions, except: [assert: 1, assert: 2, refute: 1, refute: 2]
      import ExMatchers.Assertions

      # Bring in ~> and ~>> operators
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
    a ~>> b == []
  end

  def a ~>> b do
    ExMatchers.Matchable.mismatches(b, a)
  end
end
