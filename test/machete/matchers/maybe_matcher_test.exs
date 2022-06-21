defmodule MaybeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.MaybeMatcher

  test "produces a useful mismatch for mismatches" do
    assert 123 ~>> maybe(string()) ~> mismatch("123 is not a string")
  end
end
