defmodule MaybeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches nil" do
    assert nil ~> maybe(string())
  end

  test "matches the provided matcher" do
    assert "abc" ~> maybe(string())
  end

  test "produces a useful mismatch for mismatches" do
    assert 123 ~>> maybe(string()) ~> mismatch("123 is not a string")
  end
end
