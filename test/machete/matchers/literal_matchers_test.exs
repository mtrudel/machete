defmodule LiteralMatchersTest do
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

  describe "regex matchers" do
    test "matches regexes against strings" do
      assert "abc" ~> ~r/abc/
    end

    test "produces a useful mismatch for non strings" do
      assert 1 ~>> ~r/abc/ ~> mismatch("1 is not a string")
    end

    test "produces a useful mismatch on non-matching values" do
      assert "ABC"
             ~>> ~r/abc/
             ~> mismatch("\"ABC\" does not match ~r/abc/")
    end
  end

  describe "struct matches" do
    defmodule TestStruct do
      defstruct a: nil
    end

    defmodule OtherTestStruct do
      defstruct a: nil
    end

    test "matches equivalent types" do
      assert %TestStruct{a: 1} ~> %TestStruct{a: integer()}
    end

    test "produces a useful mismatch for mismatched struct types" do
      assert %TestStruct{a: 1}
             ~>> %OtherTestStruct{a: integer()}
             ~> mismatch("Struct types do not match")
    end

    test "produces a useful mismatch for non-struct types" do
      assert 1
             ~>> %OtherTestStruct{a: integer()}
             ~> mismatch("1 is not a struct")
    end

    test "produces a useful mismatch when comparing maps to structs" do
      assert %{a: 1}
             ~>> %TestStruct{a: integer()}
             ~> mismatch("%{a: 1} is not a struct")
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
        PID => Process.list(),
        Port => Port.list(),
        Reference => [make_ref(), make_ref()]
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
        assert type_example_a
               ~>> type_example_b
               ~> mismatch(
                 "#{inspect(type_example_a)} is not equal to #{inspect(type_example_b)}"
               )
      end
    end

    test "values of different types do not match" do
      for {type_a, type_a_examples} <- types(),
          {type_b, type_b_examples} <- types(),
          type_a != type_b,
          type_a_example <- type_a_examples,
          type_b_example <- type_b_examples do
        refute type_a_example ~> type_b_example

        assert type_a_example
               ~>> type_b_example
               ~> mismatch(
                 "#{inspect(type_a_example)} is not equal to #{inspect(type_b_example)}"
               )
      end
    end
  end
end
