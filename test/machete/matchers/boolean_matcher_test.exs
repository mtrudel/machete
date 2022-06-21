defmodule BooleanMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.BooleanMatcher

  test "produces a useful mismatch for non booleans" do
    assert 1 ~>> boolean() ~> mismatch("1 is not a boolean")
  end
end
