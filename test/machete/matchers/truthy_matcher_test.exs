defmodule TruthyMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches truthy" do
    assert "abc" ~> truthy()
  end

  test "produces a useful mismatch for nil" do
    assert nil ~>> truthy() ~> mismatch("nil is not truthy")
  end

  test "produces a useful mismatch for false" do
    assert false ~>> truthy() ~> mismatch("false is not truthy")
  end
end
