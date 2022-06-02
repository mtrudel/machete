defmodule ExMatchers.Mismatch do
  @type t :: %__MODULE__{
          path: [term()],
          message: String.t()
        }

  defstruct path: [], message: nil
end
