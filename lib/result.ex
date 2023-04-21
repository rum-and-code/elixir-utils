defmodule Result do
  @moduledoc """
  A result is a 2-tuple in the form of {:ok, value} or {:error, error}.

  The term Result comes from the Rust programming language, where Result is a type
  representing either a Ok(value) or a Err(error).

  This module is a collection of function for interacting with such tuples, which we tend to do often.

  For example, we can reduce the following with statement to a simple series of Result pipes:

    ```elixir
    with {:ok, user} <- Users.get_user(user_id),
         {:ok, user} <- Users.update_user(user),
         :ok <- PubSub.broadcast({:user_updated, user}) do
      {:ok, user}
    else
      {:error, error} -> {:error, error}
    end
    ```

    ```elixir
    Users.get_user(user_id)
    |> Result.map(&Users.update_user/1)
    |> Result.tap(&PubSub.broadcast({:user_updated, &1})
    ```

  Any error will be passed through the pipe, and the result will be returned as is.
  """

  @type t() :: {:ok, any()} | {:error, any()}
  @type t(ok_type) :: {:ok, ok_type} | {:error, any()}
  @type t(ok_type, error_type) :: {:ok, ok_type} | {:error, error_type}

  @spec ok(t() | any()) :: t()
  def ok({:ok, _} = value), do: value
  def ok({:error, _} = error), do: error
  def ok(value), do: {:ok, value}

  def ok?({type, _}), do: type == :ok

  @spec map(t(), (any() -> any())) :: t()
  @doc """
  Invokes `f` on the wrapped value and returns its result, wrapped. Passes any error through.
  """
  def map({:ok, value}, f), do: ok(f.(value))
  def map({:error, _} = error, _), do: error

  @spec tap(t(), (any() -> any())) :: t()
  @doc """
  Returns the result as is, but invokes `f` on the wrapped value if :ok
  """
  def tap({:ok, value} = result, f) do
    f.(value)
    result
  end

  def tap({:error, _} = result, _), do: result

  @spec tap_error(t(), (any() -> any())) :: t()
  @doc """
  Returns the result as is, but invokes `f` on the wrapped value if :error
  """
  def tap_error({:error, error} = result, f) do
    f.(error)
    result
  end

  def tap_error(result, _), do: result

  @spec reduce([t()]) :: t()
  def reduce(results), do: Enum.reduce(results, {:ok, []}, &reducer/2)

  defp reducer({:ok, value}, {:ok, values}), do: {:ok, values ++ [value]}
  defp reducer({:ok, _}, {:error, _} = errors), do: errors
  defp reducer({:error, error}, {:error, errors}), do: {:error, errors ++ [error]}
  defp reducer({:error, error}, {:ok, _}), do: {:error, [error]}

  @spec error?(t()) :: boolean()
  def error?({:error, _}), do: true
  def error?({:ok, _}), do: false

  def map_error({:ok, _} = result, _), do: result
  def map_error({:error, error}, f), do: ok(f.(error))

  @spec unwrap(t()) :: any()
  @doc """
  Returns the :ok value, or the result as-is if :error
  """
  def unwrap({:ok, value}), do: value
  def unwrap(result), do: result

  @spec unwrap!(t()) :: any()
  @doc """
  Returns the wrapped value if :ok.
  Throws an error if :error
  """
  def unwrap!({:ok, value}), do: value

  def unwrap!({:error, _} = error),
    do: raise(ArgumentError, message: "Tried to unwrap error value: #{inspect(error)}")

  @doc """
  Returns the wrapped value if :ok.
  Returns the default value if :error
  """
  @spec unwrap_or(t(), term()) :: term()
  def unwrap_or({:ok, value}, _), do: value
  def unwrap_or({:error, _}, default), do: default
end
