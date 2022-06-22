defmodule ReferenceMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.ReferenceMatcher

  test "produces a useful mismatch for non references" do
    assert 1 ~>> reference() ~> mismatch("1 is not a reference")
  end
end
