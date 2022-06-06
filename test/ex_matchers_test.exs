defmodule ExMatchersTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "the ~> operator is defined and returns success" do
    assert 1 ~> 1
  end

  test "the ~> operator is defined and returns failure" do
    refute 1 ~> 0
  end

  test "the ~>> operator is defined and returns mismatches" do
    assert 1 ~>> 0 == [%ExMatchers.Mismatch{message: "1 is not equal to 0", path: []}]
  end
end
