defmodule ExMatchers.Assertions do
  defmacro assert({:~>, meta, [left, right]} = assertion) do
    code = escape_quoted(:assert, meta, assertion)

    quote bind_quoted: [left: left, right: right, code: code] do
      case(left ~>> right) do
        [] ->
          true

        _mismatches ->
          raise ExUnit.AssertionError,
            context: :~>,
            expr: code,
            message: "Assertion with ~> failed"
      end
    end
  end

  defmacro assert(assert) do
    quote do
      ExUnit.Assertions.assert(unquote(assert))
    end
  end

  defmacro assert(assert, message) do
    quote do
      ExUnit.Assertions.assert(unquote(assert), unquote(message))
    end
  end

  defmacro refute({:~>, meta, [_left, _right]} = assertion) do
    code = escape_quoted(:refute, meta, assertion)

    quote do
      if unquote(assertion) do
        raise ExUnit.AssertionError,
          context: :~>,
          expr: unquote(code),
          message: "Refute with ~> failed, both sides match"
      end
    end
  end

  defmacro refute(assert) do
    quote do
      ExUnit.Assertions.refute(unquote(assert))
    end
  end

  defmacro refute(assert, message) do
    quote do
      ExUnit.Assertions.refute(unquote(assert), unquote(message))
    end
  end

  defp escape_quoted(kind, meta, expr) do
    Macro.escape({kind, meta, [expr]}, prune_metadata: true)
  end
end
