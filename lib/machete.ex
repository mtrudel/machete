defmodule Machete do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      # Take ExUnit's builtin assert and refute macros out of scope
      # (we'll call to them explicitly as a fallback in Machete.Assertions)
      import ExUnit.Assertions, except: [assert: 1, assert: 2, refute: 1, refute: 2]
      import Machete.Assertions

      # Bring in ~> and ~>> operators
      import Machete

      # Bring in matcher builders
      import Machete.AnyMatcher
      import Machete.BooleanMatcher
      import Machete.DateMatcher
      import Machete.DateTimeMatcher
      import Machete.FloatMatcher
      import Machete.IntegerMatcher
      import Machete.ISO8601DateTimeMatcher
      import Machete.NaiveDateTimeMatcher
      import Machete.StringMatcher
      import Machete.TimeMatcher
    end
  end

  def a ~> b do
    a ~>> b == []
  end

  def a ~>> b do
    Machete.Matchable.mismatches(b, a) || []
  end
end
