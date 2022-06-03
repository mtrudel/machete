defmodule LiteralMatchersTest do
  use ExUnit.Case, async: true
  use ExMatchers

  describe "DateTime matchers" do
    test "matches datetimes against identical datetimes" do
      assert ~U[2022-04-26T01:23:45Z] ~> ~U[2022-04-26T01:23:45Z]
    end

    test "matches datetimes against identical datetimes across timezones" do
      datetime = ~U[2022-04-26T01:23:45Z]
      shifted_datetime = %{datetime | hour: 2, utc_offset: 3600}
      assert datetime ~> shifted_datetime
    end

    test "does not match non-identical datetimes" do
      refute ~U[2022-04-26T01:23:45Z] ~> ~U[2022-12-25T00:00:00Z]
    end

    test "does not match when matching against a non-datetime" do
      refute 123 ~> ~U[2021-04-26T01:23:45Z]
    end
  end

  describe "NaiveDateTime matchers" do
    test "matches naive datetimes against identical naive datetimes" do
      assert ~N[2022-04-26T01:23:45] ~> ~N[2022-04-26T01:23:45]
    end

    test "does not match non-identical naive datetimes" do
      refute ~N[2022-04-26T01:23:45] ~> ~N[2022-12-25T00:00:00]
    end

    test "does not match when matching against a non-naive datetime" do
      refute 123 ~> ~N[2021-04-26T01:23:45]
    end
  end

  describe "Date matchers" do
    test "matches dates against identical dates" do
      assert ~D[2022-04-26] ~> ~D[2022-04-26]
    end

    test "does not match non-identical dates" do
      refute ~D[2022-04-26] ~> ~D[2022-12-25]
    end

    test "does not match when matching against a non-date" do
      refute 123 ~> ~D[2021-04-26]
    end
  end

  describe "Time matchers" do
    test "matches times against identical times" do
      assert ~T[01:23:45] ~> ~T[01:23:45]
    end

    test "does not match non-identical times" do
      refute ~T[01:23:45] ~> ~T[00:00:00]
    end

    test "does not match when matching against a non-time" do
      refute 123 ~> ~T[01:23:45]
    end
  end

  describe "regex matchers" do
    test "matches regexes against strings" do
      assert "abc" ~> ~r/abc/
    end

    test "does not match non-matching regexes" do
      refute "def" ~> ~r/abc/
    end

    test "does not match when matching against a non-string" do
      refute 123 ~> ~r/123/
    end
  end

  describe "inter/intra-type literal (in)equalities)" do
    def types do
      %{
        Atom => [:a, :b, true, false, nil],
        BitString => [<<>>, <<1::4>>, <<1>>, <<2>>],
        Float => [0.0, 1.0],
        Function => [fn -> nil end, & &1, &Kernel.max/2],
        Integer => [0, 1],
        List => [[], [1], [1, 2]],
        Map => [%{}, %{a: 1}, %{"a" => 1}],
        PID => Process.list(),
        Port => Port.list(),
        Reference => [make_ref(), make_ref()],
        Tuple => [{}, {1}, {1, 2}]
      }
    end

    test "values of all types match against themselves" do
      for {_type, type_examples} <- types(),
          type_example <- type_examples do
        assert type_example ~> type_example
      end
    end

    test "different values of the same type do not match" do
      for {_type, type_examples} <- types(),
          type_example_a <- type_examples,
          type_example_b <- type_examples,
          type_example_a != type_example_b do
        refute type_example_a ~> type_example_b
      end
    end

    test "values of different types do not match" do
      for {type_a, type_a_examples} <- types(),
          {type_b, type_b_examples} <- types(),
          type_a != type_b,
          type_a_example <- type_a_examples,
          type_b_example <- type_b_examples do
        refute type_a_example ~> type_b_example
      end
    end
  end
end
