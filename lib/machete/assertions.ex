defmodule Machete.Assertions do
  @moduledoc false

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
