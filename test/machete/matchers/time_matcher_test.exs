defmodule TimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  setup do
    {:ok, time: Time.utc_now()}
  end

  test "matches times", context do
    assert context.time ~> time()
  end

  test "matches on precision match", context do
    assert context.time ~> time(precision: 6)
  end

  test "matches on :now roughly match" do
    assert Time.utc_now() ~> time(roughly: :now)
  end

  test "matches on roughly match" do
    assert ~T[00:00:00.000000] ~> time(roughly: ~T[00:00:05.000000])
  end

  test "matches on :now before match" do
    assert ~T[00:00:00.000000] ~> time(before: :now)
  end

  test "matches on before match" do
    assert ~T[00:00:00.000000] ~> time(before: ~T[00:00:01.000000])
  end

  test "matches on :now after match" do
    assert ~T[23:59:59.999999] ~> time(after: :now)
  end

  test "matches on after match" do
    assert ~T[00:00:01.000000] ~> time(after: ~T[00:00:00.000000])
  end

  test "produces a useful mismatch for non Times" do
    assert 1 ~>> time(precision: 6) ~> mismatch("1 is not a Time")
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.time
           ~>> time(precision: 0)
           ~> mismatch("#{inspect(context.time)} has precision 6, expected 0")
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
