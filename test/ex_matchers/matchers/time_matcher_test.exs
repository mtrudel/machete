defmodule TimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  setup do
    {:ok, time: Time.utc_now()}
  end

  test "matches times", context do
    assert context.time ~> time()
  end

  test "matches on precision match", context do
    assert context.time ~> time(precision: 6)
  end

  test "produces a useful mismatch for non Times" do
    assert 1
           ~>> time(precision: 6)
           ~> [%ExMatchers.Mismatch{message: "1 is not a Time", path: []}]
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.time
           ~>> time(precision: 0)
           ~> [
             %ExMatchers.Mismatch{
               message: "#{inspect(context.time)} has precision 6, expected 0",
               path: []
             }
           ]
  end
end
