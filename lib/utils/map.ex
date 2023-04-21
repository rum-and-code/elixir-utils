defmodule Utils.Map do
  @moduledoc """
  This module is a collection of utility functions to manipulate maps.
  """

  @doc ~S"""
  Turns a string-keyed map into an atom-keyed map

  For converting keys from strings to atoms, uses `String.to_existing_atom` by default for security purposes.
  This can be overridden by passing a function as second argument.

  ## Examples

    iex> Utils.Map.atomize_keys(%{"foo" => "bar", "baz" => "bix"})
    %{foo: "bar", baz: "bix"}

    iex> Utils.Map.atomize_keys(%{foo: "bar"})
    %{foo: "bar"}

    iex> Utils.Map.atomize_keys(%{})
    %{}
  """
  @spec atomize_keys(%{binary() => any()}, (binary() -> atom())) :: %{atom() => any()}
  def atomize_keys(m, f \\ &String.to_existing_atom/1) do
    Enum.into(m, %{}, fn
      {k, v} when is_atom(k) -> {k, v}
      {k, v} when is_binary(k) -> {f.(k), v}
    end)
  end

  @spec transform_keys(map(), (any() -> any())) :: map()
  def transform_keys(m, f) do
    Enum.into(m, %{}, fn
      {k, v} -> {f.(k), v}
    end)
  end

  def transform_values(m, f, keys) do
    Enum.reduce(keys, m, fn k, m ->
      Map.update(m, k, nil, f)
    end)
  end

  @doc ~S"""
  Trim the specified fields of a map

  ## Examples

    iex> Utils.Map.trim_fields(%{foo: "bar ", baz: "bix "}, [:foo])
    %{foo: "bar", baz: "bix "}

    iex> Utils.Map.trim_fields(%{foo: "bar ", baz: "bix "}, [:foo, :baz])
    %{foo: "bar", baz: "bix"}

    iex> Utils.Map.trim_fields(%{}, [])
    %{}
  """
  @spec trim_fields(map(), []) :: map()
  def trim_fields(map, fields \\ []) do
    Enum.reduce(fields, map, fn f, m ->
      cond do
        is_list(f) -> update_in(m, f, &maybe_trim/1)
        f in Map.keys(m) -> Map.update!(m, f, &maybe_trim/1)
        true -> m
      end
    end)
  end

  def maybe_trim(s) when is_binary(s), do: String.trim(s)
  def maybe_trim(v), do: v
end
