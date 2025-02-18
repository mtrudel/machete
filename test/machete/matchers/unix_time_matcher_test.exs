defmodule Machete.UnixTimeMatcherTest do
  use ExUnit.Case

  use Machete

  import Machete.Mismatch

  doctest Machete.UnixTimeMatcher

  setup do
    {:ok, time: :os.system_time(:millisecond)}
  end

  test "produces a useful mismatch for non unix time" do
    assert ~T[00:00:00]
           ~>> unix_time()
           ~> mismatch("~T[00:00:00] is not an integer that represents a unix time")
  end

  test "produces a useful mismatch for exactly mismatches" do
    assert 1_681_059_951_018
           ~>> unix_time(exactly: 1_681_059_951_019)
           ~> mismatch("1681059951018 is not equal to 1681059951019")
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert 1_681_059_951_018
           ~>> unix_time(roughly: 1_681_060_006_343)
           ~> mismatch("1681059951018 is not roughly equal to 1681060006343")
  end

  test "produces a useful mismatch for before mismatches" do
    assert 1_681_059_951_018
           ~>> unix_time(before: 1_681_059_951_000)
           ~> mismatch("1681059951018 is not before 1681059951000")
  end

  test "produces a useful mismatch for after mismatches" do
    assert 1_681_059_951_018
           ~>> unix_time(after: 1_681_059_951_999)
           ~> mismatch("1681059951018 is not after 1681059951999")
  end
end
