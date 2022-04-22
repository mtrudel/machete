defmodule DateTimeMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches datetimes" do
    assert DateTime.utc_now() ~> ExMatchers.datetime()
  end
end
