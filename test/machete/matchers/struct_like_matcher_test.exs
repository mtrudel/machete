defmodule StructLikeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.StructLikeMatcher

  test "produces a useful mismatch for type mismatches" do
    assert %URI{}
           ~>> struct_like(DateTime, %{})
           ~> mismatch("#{inspect(%URI{})} is not a DateTime")
  end

  test "produces a useful mismatch for field mismatches" do
    assert %URI{}
           ~>> struct_like(URI, %{host: "example.com"})
           ~> mismatch("nil is not equal to \"example.com\"", :host)
  end
end
