defmodule SupersetMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches on exact match" do
    assert %{a: 1} ~> superset(%{a: 1})
  end

  test "matches on superset when proper superset" do
    assert %{a: 1, b: 1} ~> superset(%{a: 1})
  end

  test "produces a useful mismatch for subset mismatches" do
    assert %{b: 1} ~>> superset(%{a: 1}) ~> mismatch("Missing key", :a)
  end

  test "produces a useful mismatch for nested mismatches" do
    assert %{a: 1} ~>> superset(%{a: float()}) ~> mismatch("1 is not a float", :a)
  end

  test "produces a useful mismatch for when value is not a map" do
    assert 1 ~>> superset(%{a: 1}) ~> mismatch("1 is not a map")
  end
end
