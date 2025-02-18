defmodule DateMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.DateMatcher

  test "produces a useful mismatch for non Dates" do
    assert 1 ~>> date() ~> mismatch("1 is not a Date")
  end

  test "produces a useful mismatch for exactly mismatches" do
    assert ~D[2020-01-01]
           ~>> date(exactly: ~D[3000-01-01])
           ~> mismatch("~D[2020-01-01] is not equal to ~D[3000-01-01]")
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~D[2020-01-01]
           ~>> date(roughly: ~D[3000-01-01])
           ~> mismatch("~D[2020-01-01] is not roughly equal to ~D[3000-01-01]")
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~D[3000-01-01]
           ~>> date(before: ~D[2020-01-01])
           ~> mismatch("~D[3000-01-01] is not before ~D[2020-01-01]")
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~D[2020-01-01]
           ~>> date(after: ~D[3000-01-01])
           ~> mismatch("~D[2020-01-01] is not after ~D[3000-01-01]")
  end
end
