defmodule ExMatchersTest do
  use ExUnit.Case
  doctest ExMatchers

  test "greets the world" do
    assert ExMatchers.hello() == :world
  end
end
