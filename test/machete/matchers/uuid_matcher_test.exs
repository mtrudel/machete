defmodule UUIDMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.UUIDMatcher

  @v4 "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  @nil_uuid "00000000-0000-0000-0000-000000000000"
  @max_uuid "ffffffff-ffff-ffff-ffff-ffffffffffff"

  @versions %{
    1 => "3d2a443b-d3fe-11f1-8a29-b025aa67f8a6",
    2 => "000001f5-8f5c-21ef-8a00-02004e1d0c3a",
    3 => "9073926b-929f-31c2-abc9-fad77ae3e8eb",
    4 => "1caae22b-58e5-47da-a7ef-1a923ce6a216",
    5 => "cfbff0d1-9375-5685-968c-48ce8b15ae17",
    6 => "1ec9414c-232a-6b00-b3c8-9f6bdeced846",
    7 => "017f22e2-79b0-7cc3-98c4-dc0c0c07398f",
    8 => "2489e9ad-2ee2-8e00-8ec9-32d5f69181c0"
  }

  # Type and format

  test "produces a useful mismatch for non strings" do
    assert 1 ~>> uuid() ~> mismatch("1 is not a string")
  end

  test "produces a useful mismatch for malformed UUIDs" do
    assert "abc" ~>> uuid() ~> mismatch("\"abc\" is not a valid UUID")
  end

  test "rejects non-hex characters" do
    assert "g47ac10b-58cc-4372-a567-0e02b2c3d479"
           ~>> uuid()
           ~> mismatch("\"g47ac10b-58cc-4372-a567-0e02b2c3d479\" is not a valid UUID")
  end

  test "rejects uppercase UUIDs by default" do
    upper = String.upcase(@v4)
    assert upper ~>> uuid() ~> mismatch("#{inspect(upper)} is not a valid UUID")
  end

  test "rejects UUIDs with trailing content" do
    assert (@v4 <> "\n") ~>> uuid() ~> mismatch("#{inspect(@v4 <> "\n")} is not a valid UUID")
  end

  # Case

  test "matches lowercase UUIDs by default" do
    assert @v4 ~> uuid()
    assert @v4 ~> uuid(case: :lower)
  end

  test "matches uppercase UUIDs when case is :upper" do
    assert String.upcase(@v4) ~> uuid(case: :upper)
  end

  test "rejects lowercase UUIDs when case is :upper" do
    assert @v4 ~>> uuid(case: :upper) ~> mismatch("#{inspect(@v4)} is not a valid UUID")
  end

  test "rejects mixed case UUIDs when case is :lower or :upper" do
    mixed = "F47AC10B-58cc-4372-a567-0e02b2c3d479"
    assert mixed ~>> uuid(case: :lower) ~> mismatch("#{inspect(mixed)} is not a valid UUID")
    assert mixed ~>> uuid(case: :upper) ~> mismatch("#{inspect(mixed)} is not a valid UUID")
  end

  test "matches lowercase, uppercase and mixed case UUIDs when case is :any" do
    assert @v4 ~> uuid(case: :any)
    assert String.upcase(@v4) ~> uuid(case: :any)
    assert "F47AC10B-58cc-4372-A567-0e02b2c3d479" ~> uuid(case: :any)
  end

  test "checks the version and variant of uppercase UUIDs" do
    upper = String.upcase(@v4)
    assert upper ~> uuid(version: 4, case: :upper)

    assert upper
           ~>> uuid(version: 7, case: :upper)
           ~> mismatch("#{inspect(upper)} is not a version 7 UUID")

    bad = String.upcase("f47ac10b-58cc-4372-c567-0e02b2c3d479")

    assert bad
           ~>> uuid(version: 4, case: :upper)
           ~> mismatch("#{inspect(bad)} does not use the RFC 9562 UUID variant")
  end

  # No version given

  test "matches any well formed UUID when no version is given" do
    assert @v4 ~> uuid()
    assert "00000000-0000-0000-0000-000000000001" ~> uuid()
  end

  test "matches the nil UUID when no version is given" do
    assert @nil_uuid ~> uuid()
  end

  test "matches the max UUID when no version is given" do
    assert @max_uuid ~> uuid()
  end

  # Version given

  for {version, example} <- @versions do
    test "matches version #{version} UUIDs" do
      assert unquote(example) ~> uuid(version: unquote(version))
    end

    test "rejects version #{version} UUIDs when another version is expected" do
      other = rem(unquote(version), 8) + 1

      assert unquote(example)
             ~>> uuid(version: other)
             ~> mismatch("#{inspect(unquote(example))} is not a version #{other} UUID")
    end
  end

  test "produces a useful mismatch for the nil UUID when a version is given" do
    assert @nil_uuid
           ~>> uuid(version: 4)
           ~> mismatch("#{inspect(@nil_uuid)} is not a version 4 UUID")
  end

  test "produces a useful mismatch for the max UUID when a version is given" do
    assert @max_uuid
           ~>> uuid(version: 7)
           ~> mismatch("#{inspect(@max_uuid)} is not a version 7 UUID")
  end

  test "produces a useful mismatch for variant mismatches" do
    bad = "f47ac10b-58cc-4372-c567-0e02b2c3d479"

    assert bad
           ~>> uuid(version: 4)
           ~> mismatch("#{inspect(bad)} does not use the RFC 9562 UUID variant")
  end

  # Option validation

  test "raises when provided with an unknown case" do
    assert_raise(ArgumentError, "`case` must be :lower, :upper or :any, got: :foo", fn ->
      uuid(case: :foo)
    end)
  end

  for version <- [0, 9, "4", 4.0, :v4] do
    test "raises when provided with the invalid version #{inspect(version)}" do
      message = "`version` must be an integer from 1 to 8, got: #{inspect(unquote(version))}"

      assert_raise(ArgumentError, message, fn -> uuid(version: unquote(version)) end)
    end
  end
end
