defmodule DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

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

  test "matches on :now roughly match" do
    assert DateTime.utc_now() ~> datetime(roughly: :now)
  end

  test "matches on roughly match" do
    assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(roughly: ~U[2020-01-01 00:00:05.000000Z])
  end

  test "matches on :now before match" do
    assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(before: :now)
  end

  test "matches on before match" do
    assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(before: ~U[3000-01-01 00:00:00.000000Z])
  end

  test "matches on :now after match" do
    assert ~U[3000-01-01 00:00:00.000000Z] ~> datetime(after: :now)
  end

  test "matches on after match" do
    assert ~U[3000-01-01 00:00:00.000000Z] ~> datetime(after: ~U[2020-01-01 00:00:00.000000Z])
  end

  test "produces a useful mismatch for non DateTimes" do
    assert 1
           ~>> datetime(precision: 6)
           ~> mismatch("1 is not a DateTime")
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.datetime
           ~>> datetime(precision: 0)
           ~> mismatch("#{inspect(context.datetime)} has precision 6, expected 0")
  end

  test "produces a useful mismatch for time zone mismatches", context do
    assert context.datetime
           ~>> datetime(time_zone: "America/Chicago")
           ~> mismatch(
             "#{inspect(context.datetime)} has time zone Etc/UTC, expected America/Chicago"
           )
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~U[2020-01-01 00:00:00.000000Z]
           ~>> datetime(roughly: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not within 10 seconds of ~U[3000-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~U[3000-01-01 00:00:00.000000Z]
           ~>> datetime(before: ~U[2020-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[3000-01-01 00:00:00.000000Z] is not before ~U[2020-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~U[2020-01-01 00:00:00.000000Z]
           ~>> datetime(after: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not after ~U[3000-01-01 00:00:00.000000Z]"
           )
  end
end
