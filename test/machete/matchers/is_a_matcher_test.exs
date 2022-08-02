defmodule IsAMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.IsAMatcher

  test "produces a useful mismatch for type mismatches" do
    assert %URI{}
           ~>> is_a(DateTime)
           ~> mismatch(
             "%URI{authority: nil, fragment: nil, host: nil, path: nil, port: nil, query: nil, scheme: nil, userinfo: nil} is not a DateTime"
           )
  end
end
