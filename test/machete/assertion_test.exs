defmodule AssertionTest do
  use ExUnit.Case, async: true
  use Machete

  test "matcher assertions pass" do
    result = assert %{a: 1} ~> %{a: integer()}
    assert result === true
  end

  test "ExUnit assertions pass" do
    result = assert true == true
    assert result === true
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
             message:
               "Assertion with ~> failed\n\nMismatches:\n\n  1) .a: 1.0 is not an integer\n"
           }
  end

  test "ExUnit assertions fail with useful exceptions" do
    e = get_assertion_error(fn -> assert false end)

    assert e
           ~> %ExUnit.AssertionError{
             args: :ex_unit_no_meaningful_value,
             context: :==,
             doctest: :ex_unit_no_meaningful_value,
             expr: {:assert, [], [false]},
             left: :ex_unit_no_meaningful_value,
             message: "Expected truthy, got false",
             right: :ex_unit_no_meaningful_value
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
    result = refute %{a: 1.0} ~> %{a: integer()}
    assert result === false
  end

  test "ExUnit refutations pass" do
    result = refute true == false
    assert result === false
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
