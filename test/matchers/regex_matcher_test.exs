defmodule RegexMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches regexes against strings" do
    assert "abc" ~> ~r/abc/
  end

  test "does not match non-matching regexes" do
    refute "def" ~> ~r/abc/
  end

  test "does not match when matching against a non-string" do
    refute 123 ~> ~r/123/
  end
end
