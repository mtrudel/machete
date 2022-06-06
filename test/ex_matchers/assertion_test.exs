defmodule AssertionTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matcher assertions pass" do
    assert %{a: 1} ~> %{a: integer()}
  end

  test "ExUnit assertions pass" do
    assert true == true
  end

  test "matcher assertions fail with useful exceptions" do
    e = get_assertion_error(fn -> assert %{a: 1.0} ~> %{a: integer()} end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :~>,
             doctest: :ex_unit_no_meaningful_value,
             expr:
               {:assert, [line: integer()],
                [
                  {:~>, [line: integer()],
                   [
                     {:%{}, [line: integer()], [a: 1.0]},
                     {:%{}, [line: integer()], [a: {:integer, [line: integer()], []}]}
                   ]}
                ]},
             message: "Assertion with ~> failed"
           }
  end

  test "ExUnit assertions fail with useful exceptions" do
    e = get_assertion_error(fn -> assert true == false end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :==,
             doctest: :ex_unit_no_meaningful_value,
             expr: {:assert, [line: integer()], [{:==, [line: integer()], [true, false]}]},
             left: true,
             message: "Assertion with == failed",
             right: false
           }
  end

  test "assertions fail with custom messages" do
    e = get_assertion_error(fn -> assert(%{a: 1.0} ~> %{a: integer()}, "bad time") end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :==,
             doctest: :ex_unit_no_meaningful_value,
             expr: :ex_unit_no_meaningful_value,
             left: :ex_unit_no_meaningful_value,
             message: "bad time",
             right: :ex_unit_no_meaningful_value
           }
  end

  test "matcher refutations pass" do
    refute %{a: 1.0} ~> %{a: integer()}
  end

  test "ExUnit refutations pass" do
    refute true == false
  end

  test "matcher refutations fail with useful exceptions" do
    e = get_assertion_error(fn -> refute %{a: 1} ~> %{a: integer()} end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :~>,
             doctest: :ex_unit_no_meaningful_value,
             expr:
               {:refute, [line: integer()],
                [
                  {:~>, [line: integer()],
                   [
                     {:%{}, [line: integer()], [a: 1]},
                     {:%{}, [line: integer()], [a: {:integer, [line: integer()], []}]}
                   ]}
                ]},
             left: :ex_unit_no_meaningful_value,
             message: "Refute with ~> failed, both sides match",
             right: :ex_unit_no_meaningful_value
           }
  end

  test "ExUnit refutations fail with useful exceptions" do
    e = get_assertion_error(fn -> refute true == true end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :==,
             doctest: :ex_unit_no_meaningful_value,
             expr: {:refute, [line: integer()], [{:==, [line: integer()], [true, true]}]},
             left: true,
             message: "Refute with == failed, both sides are exactly equal",
             right: :ex_unit_no_meaningful_value
           }
  end

  test "refutations fail with custom messages" do
    e = get_assertion_error(fn -> refute(%{a: 1} ~> %{a: integer()}, "bad time") end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :==,
             doctest: :ex_unit_no_meaningful_value,
             expr: :ex_unit_no_meaningful_value,
             left: :ex_unit_no_meaningful_value,
             message: "bad time",
             right: :ex_unit_no_meaningful_value
           }
  end

  defp get_assertion_error(f) do
    f.()
  rescue
    e in [ExUnit.AssertionError] ->
      e
  end
end
