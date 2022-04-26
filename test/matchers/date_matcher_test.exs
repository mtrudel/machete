defmodule DateMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches dates" do
    assert Date.utc_today() ~> date()
  end
end
