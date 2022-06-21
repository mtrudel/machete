defmodule Machete.Assertions do
  @moduledoc """
  Macros for use within the context of ExUnit tests, to provide `~>` awareness to `assert/1` and
  `refute/1` macros. Because macros cannot be defined in multiple modules, proper use of this
  module requires the user to take `ExUnit.Assertions`' version of `assert/1` and `refute/1` out
  of scope, and to allow this module's versions of those macros to call through to
  `ExUnit.Assertions`' version for conditions other than `~>`
  """

  @doc """
  A custom implementation of the `assert/1` macro to provide support for useful errors on `~>`
  mismatches; all other patterns are passed through to `ExUnit.Assertions.assert/1`
  """
  defmacro assert({:~>, meta, [left, right]} = assertion) do
    code = Macro.escape({:assert, meta, [assertion]}, prune_metadata: true)

    quote bind_quoted: [left: left, right: right, code: code] do
      case(left ~>> right) do
        [] ->
          true

        mismatches ->
          formatted_mismatches = Machete.Mismatch.format_mismatches(mismatches, "  ")

          raise ExUnit.AssertionError,
            context: :~>,
            expr: code,
            message: "Assertion with ~> failed\n\nMismatches:\n\n#{formatted_mismatches}"
      end
    end
  end

  defmacro assert(assert) do
    quote do
      ExUnit.Assertions.assert(unquote(assert))
    end
  end

  @doc """
  A custom implementation of the `refute/1` macro to provide support for useful errors on `~>`
  mismatches; all other patterns are passed through to `ExUnit.Assertions.refute/1`
  """
  defmacro refute({:~>, meta, [_left, _right]} = assertion) do
    code = Macro.escape({:refute, meta, [assertion]}, prune_metadata: true)

    quote do
      if unquote(assertion) do
        raise ExUnit.AssertionError,
          context: :~>,
          expr: unquote(code),
          message: "Refute with ~> failed, both sides match"
      else
        false
      end
    end
  end

  defmacro refute(assert) do
    quote do
      ExUnit.Assertions.refute(unquote(assert))
    end
  end
end
