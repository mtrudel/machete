defmodule TimeMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches times" do
    assert Time.utc_now() ~> ExMatchers.time()
  end
end
