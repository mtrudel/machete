defmodule InAnyOrderMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.InAnyOrderMatcher

  test "produces a useful mismatch for no matches" do
    assert [1, 2]
           ~>> in_any_order([1, 3])
           ~> mismatch(
             "[1, 2] does not match any ordering of the specified matchers:\n\n    .1\n      1) 2 is not equal to 3\n"
           )
  end

  defmodule BigStruct do
    defstruct a: 1,
              b: 2,
              c: 3,
              d: 4,
              e: 5,
              f: 6,
              g: 7,
              h: 8,
              i: 9,
              j: 10,
              k: 11,
              l: 12,
              m: 13,
              n: 14,
              o: 15,
              p: 16,
              q: 17,
              r: 18,
              s: 19,
              t: 20,
              u: 21,
              v: 22,
              w: 23,
              x: 24,
              y: 25,
              z: 26
  end

  test "drills into structs with mismatches" do
    assert [~U[2024-01-01 01:02:03Z], ~U[2024-01-01 04:05:07Z]]
           ~>> in_any_order([
             struct_like(DateTime, %{
               hour: 1,
               minute: 2,
               second: 3
             }),
             struct_like(DateTime, %{
               hour: 4,
               minute: 5,
               second: 6
             })
           ])
           ~> mismatch(
             "[~U[2024-01-01 01:02:03Z], ~U[2024-01-01 04:05:07Z]] does not match any ordering of the specified matchers:\n\n    .1\n      1) .second: 7 is not equal to 6\n"
           )

    big_struct1 = %BigStruct{a: 14, b: 32}
    big_struct2 = %BigStruct{c: 4, d: 9}

    assert [big_struct1, big_struct2]
           ~>> in_any_order([%BigStruct{}, %BigStruct{a: 14}])
           ~> mismatch(
             "[%InAnyOrderMatcherTest.BigStruct{a: 14, b: 32, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11, l: 12, m: 13, n: 14, o: 15, p: 16, q: 17, r: 18, s: 19, t: 20, u: 21, v: 22, w: 23, x: 24, y: 25, z: 26}, %InAnyOrderMatcherTest.BigStruct{a: 1, b: 2, c: 4, d: 9, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11, l: 12, m: 13, n: 14, o: 15, p: 16, q: 17, r: 18, s: 19, t: 20, u: 21, v: 22, w: 23, x: 24, y: 25, z: 26}] does not match any ordering of the specified matchers:\n    .0\n      1) .b: 32 is not equal to 2\n\n    .1\n      1) .c: 4 is not equal to 3\n      2) .d: 9 is not equal to 4\n"
           )
  end
end
