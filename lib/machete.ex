defmodule Machete do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      # Take ExUnit's builtin assert and refute macros out of scope
      # (we'll call to them explicitly as a fallback in Machete.Assertions)
      import ExUnit.Assertions, except: [assert: 1, assert: 2, refute: 1, refute: 2]
      import Machete.Assertions

      # Bring in ~> and ~>> operators
      import Machete.Operators

      # Bring in matcher builders
      import Machete.AnyMatcher
      import Machete.BooleanMatcher
      import Machete.DateMatcher
      import Machete.DateTimeMatcher
      import Machete.FalsyMatcher
      import Machete.FloatMatcher
      import Machete.IndifferentAccessMatcher
      import Machete.IntegerMatcher
      import Machete.ISO8601DateTimeMatcher
      import Machete.ListOfMatcher
      import Machete.MapMatcher
      import Machete.MaybeMatcher
      import Machete.NaiveDateTimeMatcher
      import Machete.StringMatcher
      import Machete.SubsetMatcher
      import Machete.SupersetMatcher
      import Machete.TimeMatcher
      import Machete.TruthyMatcher
    end
  end
end
