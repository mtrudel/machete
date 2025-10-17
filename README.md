# Machete

[![Build Status](https://github.com/mtrudel/machete/workflows/Elixir%20CI/badge.svg)](https://github.com/mtrudel/machete/actions)
[![Docs](https://img.shields.io/badge/api-docs-green.svg?style=flat)](https://hexdocs.pm/machete)
[![Hex.pm](https://img.shields.io/hexpm/v/machete.svg?style=flat&color=blue)](https://hex.pm/packages/machete)

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
  against general types. A comprehensive list of Machete's built-in matchers is
  available [in the Machete
  documentation](https://hexdocs.pm/machete/Machete.html)

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

# Variables 'just work' everywhere; no pinning required:
a_number = 1
assert a_number ~> 1
assert 1 ~> a_number
assert a_number ~> a_number

# Date-like types are compared using the relevant `compare/2` function:
assert ~D[2021-02-01] ~> ~D[2021-02-01]

# Regexes match using =~ semantics:
assert "abc" ~> ~r/abc/

# Structs can be matched on a subset of their fields:
assert %User{name: "Moe"} ~> struct_like(User, name: string())
```

## Matching collections

Machete matches collections via recursive descent; any nested fields / collections will be
matched using the same heuristic:

```elixir
# Maps have their content matched element by element:
assert %{a: 1} ~> %{a: 1}

# Same for lists and tuples:
assert [1,2,3] ~> [1,2,3]
assert {:ok, :boomer} ~> {:ok, :boomer}

# This same pattern applies recursively:
assert {:ok, %{a: [1,2,3]}} ~> {:ok, %{a: [1,2,3]}}
```

## Parametric matchers

Machete comes with parametric matchers defined for a variety of types. A few
illustrative examples follow; for more details, see the [Machete
Hexdocs](https://hexdocs.pm/machete/Machete.html):

```elixir
# Matches strings
assert "abc" ~> string()

# Many parametric matchers can take optional arguments
# For example, this will match only positive integers
assert 1 ~> integer(positive: true)

# Parametric matchers make it easy to test fuzzy values:
almost_now = DateTime.utc_now()
Process.sleep(1)
assert almost_now ~> datetime(roughly: :now, time_zone: :utc)

# Of course, parametric matchers work within collections too:
assert %{name: "Moe Fonebone"} ~> %{name: string()}

# There are even parametric matchers for collections themselves:
assert [1,2,3] ~> list(elements: integer(), length: 3)
```

## Installation

Machete is [available in Hex](https://hex.pm/packages/machete), and can be
installed by adding `machete` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:machete, "~> 0.2.8"}
  ]
end
```

Documentation is published on [HexDocs](https://hexdocs.pm/machete)

## License

MIT
