defmodule AtomMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.AtomMatcher

  test "produces a useful mismatch for non atoms" do
    assert 1 ~>> atom() ~> mismatch("1 is not an atom")
  end
end
