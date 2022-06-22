defmodule LiteralDateLikeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  describe "DateTime matchers" do
    test "matches datetimes against identical datetimes" do
      assert ~U[2022-04-26T01:23:45Z] ~> ~U[2022-04-26T01:23:45Z]
    end

    test "matches datetimes against identical datetimes across timezones" do
      datetime = ~U[2022-04-26T01:23:45Z]
      shifted_datetime = %{datetime | hour: 2, utc_offset: 3600}
      assert datetime ~> shifted_datetime
    end

    test "produces a useful mismatch for non DateTimes" do
      assert 1
             ~>> ~U[2021-04-26T01:23:45Z]
             ~> mismatch("1 is not a DateTime")
    end

    test "produces a useful mismatch on non-equivalent values" do
      assert ~U[2021-05-27T02:24:46Z]
             ~>> ~U[2021-04-26T01:23:45Z]
             ~> mismatch("~U[2021-05-27 02:24:46Z] is not equal to ~U[2021-04-26 01:23:45Z]")
    end
  end

  describe "NaiveDateTime matchers" do
    test "matches naive datetimes against identical naive datetimes" do
      assert ~N[2022-04-26T01:23:45] ~> ~N[2022-04-26T01:23:45]
    end

    test "produces a useful mismatch for non NaiveDateTimes" do
      assert 1
             ~>> ~N[2021-04-26T01:23:45]
             ~> mismatch("1 is not a NaiveDateTime")
    end

    test "produces a useful mismatch on non-equivalent values" do
      assert ~N[2021-05-27T02:24:46]
             ~>> ~N[2021-04-26T01:23:45]
             ~> mismatch("~N[2021-05-27 02:24:46] is not equal to ~N[2021-04-26 01:23:45]")
    end
  end

  describe "Date matchers" do
    test "matches dates against identical dates" do
      assert ~D[2022-04-26] ~> ~D[2022-04-26]
    end

    test "produces a useful mismatch for non Dates" do
      assert 1 ~>> ~D[2021-04-26] ~> mismatch("1 is not a Date")
    end

    test "produces a useful mismatch on non-equivalent values" do
      assert ~D[2021-05-27]
             ~>> ~D[2021-04-26]
             ~> mismatch("~D[2021-05-27] is not equal to ~D[2021-04-26]")
    end
  end

  describe "Time matchers" do
    test "matches times against identical times" do
      assert ~T[01:23:45] ~> ~T[01:23:45]
    end

    test "produces a useful mismatch for non Times" do
      assert 1 ~>> ~T[01:23:45] ~> mismatch("1 is not a Time")
    end

    test "produces a useful mismatch on non-equivalent values" do
      assert ~T[02:24:46]
             ~>> ~T[01:23:45]
             ~> mismatch("~T[02:24:46] is not equal to ~T[01:23:45]")
    end
  end
end
