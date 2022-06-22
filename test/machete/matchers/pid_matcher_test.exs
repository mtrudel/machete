defmodule PIDMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.PIDMatcher

  test "produces a useful mismatch for non PIDs" do
    assert 1 ~>> pid() ~> mismatch("1 is not a PID")
  end
end
