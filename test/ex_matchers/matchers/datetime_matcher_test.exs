defmodule DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  setup do
    {:ok, datetime: DateTime.utc_now()}
  end

  test "matches datetimes", context do
    assert context.datetime ~> datetime()
  end

  test "matches on precision match", context do
    assert context.datetime ~> datetime(precision: 6)
  end

  test "matches on :utc time zone match", context do
    assert context.datetime ~> datetime(time_zone: :utc)
  end

  test "matches on time zone match", context do
    assert context.datetime ~> datetime(time_zone: "Etc/UTC")
  end

  test "produces a useful mismatch for non DateTimes" do
    assert 1
           ~>> datetime(precision: 6)
           ~> [%ExMatchers.Mismatch{message: "1 is not a DateTime", path: []}]
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.datetime
           ~>> datetime(precision: 0)
           ~> [
             %ExMatchers.Mismatch{
               message: "#{inspect(context.datetime)} has precision 6, expected 0",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for time zone mismatches", context do
    assert context.datetime
           ~>> datetime(time_zone: "America/Chicago")
           ~> [
             %ExMatchers.Mismatch{
               message:
                 "#{inspect(context.datetime)} has time zone Etc/UTC, expected America/Chicago",
               path: []
             }
           ]
  end
end
