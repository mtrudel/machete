defmodule Machete.UUIDMatcher do
  @moduledoc """
  Defines a matcher that matches UUID formatted strings
  """

  import Machete.Mismatch

  defstruct version: nil, case: :lower

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:version, 1..8},
          {:case, :lower | :upper | :any}
        ]

  @doc """
  Matches against UUID formatted strings in the canonical hyphenated form
  (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

  Takes the following arguments:

  * `version`: Requires the matched UUID to be of the specified version (1 through 8). This also
    requires the UUID to use the RFC 9562 variant. When not specified, any well formed UUID is
    matched, regardless of its version or variant
  * `case`: Requires the matched UUID to use the specified case for its hex digits. Can be
    `:lower`, `:upper`, or `:any`. Defaults to `:lower`

  Examples:

      iex> assert "6ba7b810-9dad-11d1-80b4-00c04fd430c8" ~> uuid()
      true

      iex> assert "f47ac10b-58cc-4372-a567-0e02b2c3d479" ~> uuid(version: 4)
      true

      iex> assert "F47AC10B-58CC-4372-A567-0E02B2C3D479" ~> uuid(case: :upper)
      true

      iex> assert "F47AC10B-58CC-4372-a567-0e02b2c3d479" ~> uuid(case: :any)
      true

      iex> refute "f47ac10b-58cc-4372-a567-0e02b2c3d479" ~> uuid(version: 1)
      false
  """
  @spec uuid(opts()) :: t()
  def uuid(opts \\ []) do
    matcher = struct!(__MODULE__, opts)
    validate_version!(matcher.version)
    validate_case!(matcher.case)
    matcher
  end

  defp validate_version!(nil), do: :ok
  defp validate_version!(version) when version in 1..8, do: :ok

  defp validate_version!(version),
    do: raise(ArgumentError, "`version` must be an integer from 1 to 8, got: #{inspect(version)}")

  defp validate_case!(case) when case in [:lower, :upper, :any], do: :ok

  defp validate_case!(case),
    do: raise(ArgumentError, "`case` must be :lower, :upper or :any, got: #{inspect(case)}")

  defimpl Machete.Matchable do
    @formats %{
      lower: ~r/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/,
      upper: ~r/\A[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}\z/,
      any: ~r/\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\z/
    }

    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_format(b, a.case),
           nil <- matches_version(b, a.version) do
      end
    end

    defp matches_type(b) when is_binary(b), do: nil
    defp matches_type(b), do: mismatch("#{safe_inspect(b)} is not a string")

    defp matches_format(b, case) do
      unless b =~ Map.fetch!(@formats, case),
        do: mismatch("#{safe_inspect(b)} is not a valid UUID")
    end

    defp matches_version(_, nil), do: nil

    defp matches_version(b, version) do
      <<_::binary-size(14), actual, _::binary-size(4), variant, _::binary>> = b

      cond do
        actual != ?0 + version ->
          mismatch("#{safe_inspect(b)} is not a version #{version} UUID")

        variant not in ~c"89abAB" ->
          mismatch("#{safe_inspect(b)} does not use the RFC 9562 UUID variant")

        true ->
          nil
      end
    end
  end
end
