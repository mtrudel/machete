defmodule MapMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches maps" do
    assert %{} ~> map()
  end

  test "produces a useful mismatch for map mismatches" do
    assert 123 ~>> map() ~> mismatch("123 is not a map")
  end
end
