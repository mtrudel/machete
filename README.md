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

## Installation

Machete is [available in Hex](https://hex.pm/packages/machete), and can be
installed by adding `machete` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:machete, "~> 0.2.0"}
  ]
end
```

Documentation is published on [HexDocs](https://hexdocs.pm/machete)

## License

MIT
