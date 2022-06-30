defmodule TimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.TimeMatcher

  setup do
    {:ok, time: Time.utc_now()}
  end

  test "produces a useful mismatch for non Times" do
    assert 1 ~>> time(precision: 6) ~> mismatch("1 is not a Time")
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.time
           ~>> time(precision: 0)
           ~> mismatch("#{inspect(context.time)} has precision 6, expected 0")
  end

  test "produces a useful mismatch for exactly mismatches" do
    assert ~T[00:00:00.000000]
           ~>> time(exactly: ~T[00:00:20.000000])
           ~> mismatch("~T[00:00:00.000000] is not equal to ~T[00:00:20.000000]")
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~T[00:00:00.000000]
           ~>> time(roughly: ~T[00:00:20.000000])
           ~> mismatch("~T[00:00:00.000000] is not within 10 seconds of ~T[00:00:20.000000]")
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~T[00:00:01.000000]
           ~>> time(before: ~T[00:00:00.000000])
           ~> mismatch("~T[00:00:01.000000] is not before ~T[00:00:00.000000]")
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~T[00:00:00.000000]
           ~>> time(after: ~T[00:00:01.000000])
           ~> mismatch("~T[00:00:00.000000] is not after ~T[00:00:01.000000]")
  end
end
