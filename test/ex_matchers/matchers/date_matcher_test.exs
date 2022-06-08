defmodule DateMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches dates" do
    assert Date.utc_today() ~> date()
  end

  test "matches on :today roughly match" do
    assert Date.utc_today() ~> date(roughly: :today)
  end

  test "matches on roughly match" do
    assert ~D[2020-01-01] ~> date(roughly: ~D[2020-01-02])
  end

  test "matches on :today before match" do
    assert ~D[2020-01-01] ~> date(before: :today)
  end

  test "matches on before match" do
    assert ~D[2020-01-01] ~> date(before: ~D[3000-01-01])
  end

  test "matches on :today after match" do
    assert ~D[3000-01-01] ~> date(after: :today)
  end

  test "matches on after match" do
    assert ~D[3000-01-01] ~> date(after: ~D[2020-01-01])
  end

  test "produces a useful mismatch for non Dates" do
    assert 1 ~>> date() ~> [%ExMatchers.Mismatch{message: "1 is not a Date", path: []}]
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~D[2020-01-01]
           ~>> date(roughly: ~D[3000-01-01])
           ~> [
             %ExMatchers.Mismatch{
               message: "~D[2020-01-01] is not within 1 day of ~D[3000-01-01]",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~D[3000-01-01]
           ~>> date(before: ~D[2020-01-01])
           ~> [
             %ExMatchers.Mismatch{
               message: "~D[3000-01-01] is not before ~D[2020-01-01]",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~D[2020-01-01]
           ~>> date(after: ~D[3000-01-01])
           ~> [
             %ExMatchers.Mismatch{
               message: "~D[2020-01-01] is not after ~D[3000-01-01]",
               path: []
             }
           ]
  end
end
