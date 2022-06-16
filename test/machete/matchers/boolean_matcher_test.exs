defmodule BooleanMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  test "matches true" do
    assert true ~> boolean()
  end

  test "matches false" do
    assert false ~> boolean()
  end

  test "produces a useful mismatch for non booleans" do
    assert 1 ~>> boolean() ~> [%Machete.Mismatch{message: "1 is not a boolean", path: []}]
  end
end