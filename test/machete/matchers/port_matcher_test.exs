defmodule PortMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.PortMatcher

  test "produces a useful mismatch for non ports" do
    assert 1 ~>> port() ~> mismatch("1 is not a port")
  end
end
