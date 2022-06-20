defmodule FalsyMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches nil" do
    assert nil ~> falsy()
  end

  test "matches false" do
    assert false ~> falsy()
  end

  test "produces a useful mismatch for truthy" do
    assert "abc" ~>> falsy() ~> mismatch("\"abc\" is not falsy")
  end
end
