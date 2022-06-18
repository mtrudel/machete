defmodule Machete.Operators do
  @moduledoc false

  def a ~> b do
    a ~>> b == []
  end

  def a ~>> b do
    Machete.Matchable.mismatches(b, a) || []
  end
end
