defmodule IndifferentAccessMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches on indifferent_access from atom to atom" do
    assert %{a: 1} ~> indifferent_access(%{a: 1})
  end

  test "matches on indifferent_access from string to string" do
    assert %{"a" => 1} ~> indifferent_access(%{"a" => 1})
  end

  test "matches on indifferent_access from atom to string" do
    assert %{a: 1} ~> indifferent_access(%{"a" => 1})
  end

  test "matches on indifferent_access from string to atom" do
    assert %{"a" => 1} ~> indifferent_access(%{a: 1})
  end

  test "matches on indifferent_access from term to term" do
    assert %{1 => 1} ~> indifferent_access(%{1 => 1})
  end

  test "produces a useful mismatch for indifferent_access atom to string mismatches" do
    assert %{a: 1} ~>> indifferent_access(%{"a" => 2}) ~> mismatch("1 is not equal to 2", "a")
  end

  test "produces a useful mismatch for indifferent_access string to atom mismatches" do
    assert %{"a" => 1} ~>> indifferent_access(%{a: 2}) ~> mismatch("1 is not equal to 2", :a)
  end

  test "produces a useful mismatch for when value is not a map" do
    assert 1 ~>> indifferent_access(%{a: 1}) ~> mismatch("1 is not a map")
  end
end
