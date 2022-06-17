# Machete

[![Build Status](https://github.com/mtrudel/machete/workflows/Elixir%20CI/badge.svg)](https://github.com/mtrudel/machete/actions)
[![Docs](https://img.shields.io/badge/api-docs-green.svg?style=flat)](https://hexdocs.pm/machete)
[![Hex.pm](https://img.shields.io/hexpm/v/machete.svg?style=flat&color=blue)](https://hex.pm/packages/machete)

Literate matchers for better ExUnit tests.

## Examples

```elixir
use Machete

# You can match against literals (using == semantics)
assert "abc" ~> "abc"
assert %{a: 1} ~> %{a: 1}

# ...or against regexes
assert %{a: "abc"} ~> %{a: ~r/abc/}

# ...or against types
assert %{a: 1} ~> %{a: integer()}
assert %{a: DateTime.utc_now()} ~> %{a: datetime(precision: 6)}

# ...it also nests
assert %{a: [1, 2.0, {:ok, "hi"}]} ~> %{a: [integer(), float(), {atom(), string()}]}
```

### Coming Soon

* More parametrized type matchers:
    ```elixir
    assert %{a: 1} ~> %{a: integer(odd: true)}
    assert %{a: "abcd"} ~> %{a: string(length: 4)}
    ```
* Flexible collection matchers:
    ```elixir
    assert %{a: 1} ~> map(at_least: %{a: integer(odd: true)})
    assert [3,2,1] ~> list(any_order: [1,2,3])
    ``` 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `machete` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:machete, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/machete>.

