defmodule ExMatchersTest do
  use ExUnit.Case, async: true

  import ExMatchers

  # TODO - property test the snot out of this

  describe "inter/intra-type (in)equalities)" do
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
