defmodule RegexMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  describe "regex matchers" do
    test "matches regexes against strings" do
      assert "abc" ~> ~r/abc/
    end

    test "produces a useful mismatch for non strings" do
      assert 1 ~>> ~r/abc/ ~> mismatch("1 is not a string")
    end

    test "produces a useful mismatch on non-matching values" do
      assert "ABC"
             ~>> ~r/abc/
             ~> mismatch("\"ABC\" does not match ~r/abc/")
    end
  end
end
