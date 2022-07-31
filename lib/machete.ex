defmodule Machete do
  @moduledoc """
  Machete provides ergonomic match operators to help make your ExUnit tests more literate

  The easiest way to explain Machete is to show it in action:

  ```elixir
  defmodule ExampleTest do
    use ExUnit.Case
    use Machete

    test "example test" do
      response = %{
        id: 1,
        name: "Moe Fonebone",
        is_admin: false,
        created_at: DateTime.utc_now()
      }

      assert response ~> %{
        id: integer(positive: true),
        name: string(),
        is_admin: false,
        created_at: datetime(roughly: :now, time_zone: :utc)
      }
    end
  end
  ```

  At its heart, Machete provides the following two things:

  * A new `~>` operator (the 'squiggle arrow') that does flexible matching of 
    its left operator with its right operator
  * A set of parametric matchers such as `string()` or `integer()` which can match
    against general types

  These building blocks let you define test expectations that can match data against any
  combination of literals, variables, or parametrically defined matchers

  When your matches fail, Machete provides useful error messages in ExUnit that point you directly
  at any failing matches using [jq syntax](https://stedolan.github.io/jq/manual/#Basicfilters)

  ## Matching literals & variables

  Machete matches directly against literals & variables. The following examples will all match:

  ```elixir
  # Builtin type literals all match themselves:
  assert 1 ~> 1
  assert "abc" ~> "abc"

  # Comparison is strict, using === semantics:
  refute 1.0 ~> 1
  refute "123" ~> 123

  # Variables 'just work' everywhere; no pinning required!
  a_number = 1
  assert a_number ~> 1
  assert 1 ~> a_number
  assert a_number ~> a_number

  # Date-like types are compared using the relevant `compare/2` function:
  assert ~D[2021-02-01] ~> ~D[2021-02-01]

  # Regexes match using =~ semantics:
  assert "abc" ~> ~r/abc/
  ```

  ## Type-based matchers

  Machete comes with parametric matchers defined for a variety of types. Many of these matchers
  take optional arguments to further refine matches (for example, `integer(positive: true)` will
  match positive integers). For details, see the documentation of specific matchers below. The
  following matchers are defined by Machete:

  * [`atom()`](`Machete.AtomMatcher.atom/1`) matches atoms
  * [`boolean()`](`Machete.BooleanMatcher.boolean/1`) matches boolean values
  * [`date()`](`Machete.DateMatcher.date/1`) matches `Date` instances
  * [`datetime()`](`Machete.DateTimeMatcher.datetime/1`) matches `DateTime` instances
  * [`falsy()`](`Machete.FalsyMatcher.falsy/1`) matches falsy values
  * [`float()`](`Machete.FloatMatcher.float/1`) matches float values
  * [`integer()`](`Machete.IntegerMatcher.integer/1`) matches integer values
  * [`iso8601_datetime()`](`Machete.ISO8601DateTimeMatcher.iso8601_datetime/1`) matches ISO8601 formatted strings
  * [`naive_datetime()`](`Machete.NaiveDateTimeMatcher.naive_datetime/1`) matches `NaiveDateTime` instances
  * [`pid()`](`Machete.PIDMatcher.pid/1`) matches process IDs
  * [`port()`](`Machete.PortMatcher.port/1`) matches Erlang ports
  * [`reference()`](`Machete.ReferenceMatcher.reference/1`) matches Erlang references
  * [`string()`](`Machete.StringMatcher.string/1`) matches UTF-8 binaries
  * [`term()`](`Machete.TermMatcher.term/1`) matches any term (including nil)
  * [`time()`](`Machete.TimeMatcher.time/1`) matches `Time` instances
  * [`truthy()`](`Machete.TruthyMatcher.truthy/1`) matches truthy values

  ## Collection matchers

  Collections can be matched as literals, with their contents being recursively matched. This
  usage requires knowing the exact shape of the collection up front, and may not always be
  suitable. For cases where you may need more flexible collection matching, Machete provides the
  following matchers:

  * [`indifferent_access()`](`Machete.IndifferentAccessMatcher.indifferent_access/1`) matches maps, considering similar atom and string keys to be
    equivalent
  * [`list()`](`Machete.ListMatcher.list/1`) matches lists, with optional constraints on element type & list length
  * [`map()`](`Machete.MapMatcher.map/1`) matches maps, with optional constraints on key and value types & map size
  * [`subset()`](`Machete.SubsetMatcher.subset/1`) matches maps against its intersection with a (possibly larger) map
  * [`superset()`](`Machete.SupersetMatcher.superset/1`) matches maps against its intersection with a (possibly smaller) map

  ## Miscellaneous matchers

  * [`all()`](`Machete.AllMatcher.all/1`) matches the value against a set of matchers, requiring all of them to match
  * [`any()`](`Machete.AnyMatcher.any/1`) matches the value against a set of matchers, requiring at least one of them to match
  * [`maybe()`](`Machete.MaybeMatcher.maybe/1`) matches using a specified matcher, but also matches nil
  * [`none()`](`Machete.NoneMatcher.none/1`) matches the value against a set of matchers, requiring none of them to match

  ## Write your own matchers

  Implementing your own matchers is easy! Behind the scenes, parametric matchers are plain
  functions which return structs conforming to the `Machete.Matchable` protocol. You can implement
  your own matchers by doing the same; a good place to start would be to look at something like
  the [falsy matcher](`Machete.FalsyMatcher`) as a starting point.

  For more adhoc matchers, you can also define a function which returns the output of an existing
  matcher. For example, if you wanted to define a matcher named `tags()` which would match
  a (possibly empty) list of non-empty strings without whitespace, you could do so like so:

  ```elixir
  def tags(), do: list(elements: string(empty: false, whitespace: false))

  assert %{
    tags: ["cool", "awesome", "not_lame"]
  } ~> %{
    tags: tags()
  }
  ```

  This allows you to easily DRY up your test expectations, keeping a centralized notion of what
  various formats in your data look like
  """

  @doc """
  Brings the `~>` and `~>>` operators into scope, along with `assert/1` and `refute/1` macros to
  be aware of them. Also brings the set of parameteric matchers listed above into scope. Typical
  use of this is to `use Machete` at the top of your ExUnit tests, taking care to place this after
  any `use ExUnit...` calls to ensure that the relevant `assert/1` and `refute/1` macros are
  properly scoped
  """
  defmacro __using__(_opts) do
    quote do
      # Take ExUnit's builtin assert/1 and refute/1 macros out of scope
      # (we'll call to them explicitly as a fallback in Machete.Assertions)
      import ExUnit.Assertions, except: [assert: 1, refute: 1]
      import Machete.Assertions

      # Bring in ~> and ~>> operators
      import Machete.Operators

      # Bring in matcher builders
      import Machete.AllMatcher
      import Machete.AnyMatcher
      import Machete.AtomMatcher
      import Machete.BooleanMatcher
      import Machete.DateMatcher
      import Machete.DateTimeMatcher
      import Machete.FalsyMatcher
      import Machete.FloatMatcher
      import Machete.IndifferentAccessMatcher
      import Machete.IntegerMatcher
      import Machete.ISO8601DateTimeMatcher
      import Machete.ListMatcher
      import Machete.MapMatcher
      import Machete.MaybeMatcher
      import Machete.NaiveDateTimeMatcher
      import Machete.NoneMatcher
      import Machete.PIDMatcher
      import Machete.PortMatcher
      import Machete.ReferenceMatcher
      import Machete.StringMatcher
      import Machete.SubsetMatcher
      import Machete.SupersetMatcher
      import Machete.TermMatcher
      import Machete.TimeMatcher
      import Machete.TruthyMatcher
    end
  end
end
