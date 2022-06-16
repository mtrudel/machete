defmodule NaiveDateTimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  setup do
    {:ok, datetime: NaiveDateTime.utc_now()}
  end

  test "matches naive datetimes", context do
    assert context.datetime ~> naive_datetime()
  end

  test "matches on precision match", context do
    assert context.datetime ~> naive_datetime(precision: 6)
  end

  test "matches on :now roughly match" do
    assert NaiveDateTime.utc_now() ~> naive_datetime(roughly: :now)
  end

  test "matches on roughly match" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~> naive_datetime(roughly: ~N[2020-01-01 00:00:05.000000])
  end

  test "matches on :now before match" do
    assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(before: :now)
  end

  test "matches on before match" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~> naive_datetime(before: ~N[3000-01-01 00:00:00.000000])
  end

  test "matches on :now after match" do
    assert ~N[3000-01-01 00:00:00.000000] ~> naive_datetime(after: :now)
  end

  test "matches on after match" do
    assert ~N[3000-01-01 00:00:00.000000] ~> naive_datetime(after: ~N[2020-01-01 00:00:00.000000])
  end

  test "produces a useful mismatch for non NaiveDateTimes" do
    assert 1
           ~>> naive_datetime(precision: 6)
           ~> [%Machete.Mismatch{message: "1 is not a NaiveDateTime", path: []}]
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.datetime
           ~>> naive_datetime(precision: 0)
           ~> [
             %Machete.Mismatch{
               message: "#{inspect(context.datetime)} has precision 6, expected 0",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~>> naive_datetime(roughly: ~N[3000-01-01 00:00:00.000000])
           ~> [
             %Machete.Mismatch{
               message:
                 "~N[2020-01-01 00:00:00.000000] is not within 10 seconds of ~N[3000-01-01 00:00:00.000000]",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~N[3000-01-01 00:00:00.000000]
           ~>> naive_datetime(before: ~N[2020-01-01 00:00:00.000000])
           ~> [
             %Machete.Mismatch{
               message:
                 "~N[3000-01-01 00:00:00.000000] is not before ~N[2020-01-01 00:00:00.000000]",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~>> naive_datetime(after: ~N[3000-01-01 00:00:00.000000])
           ~> [
             %Machete.Mismatch{
               message:
                 "~N[2020-01-01 00:00:00.000000] is not after ~N[3000-01-01 00:00:00.000000]",
               path: []
             }
           ]
  end
end
