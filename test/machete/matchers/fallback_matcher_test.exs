defmodule FallbackMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

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
