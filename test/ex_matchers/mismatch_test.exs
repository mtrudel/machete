defmodule MismatchTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "format_mismatches formats with numbers and indents" do
    mismatches = %{a: 1, b: [{1}]} ~>> %{a: 2, b: [{2}]}

    assert ExMatchers.Mismatch.format_mismatches(mismatches, "  ") == """
             1) .a: 1 is not equal to 2
             2) .b.[0].{0}: 1 is not equal to 2
           """
  end

  test "format_mismatches formats with numbers and indents on root mismatches" do
    mismatches = 1 ~>> 2

    assert ExMatchers.Mismatch.format_mismatches(mismatches, "  ") == """
             1) 1 is not equal to 2
           """
  end
end
