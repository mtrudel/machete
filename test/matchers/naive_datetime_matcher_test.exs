defmodule NaiveDateTimeMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches naive datetimes" do
    assert NaiveDateTime.utc_now() ~> ExMatchers.naive_datetime()
  end
end
