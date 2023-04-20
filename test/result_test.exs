defmodule ResultTest do
  use ExUnit.Case

  describe("Result.tap/2") do
    test("it runs an :ok result through the given function and returns the result untouched") do
      {:ok, value} = Result.tap({:ok, 1}, fn val -> send(self(), {:called_with, val}) end)

      assert value == 1
      assert_received {:called_with, 1}
    end

    test("it does not invoke the function if result is :error") do
      Result.tap({:error, :not_cool}, fn _ -> send(self(), :nope) end)
      refute_received :nope
    end
  end

  describe("Result.tap_error/2") do
    test("it runs an :error result through the given function and returns the result untouched") do
      {:error, value} = Result.tap_error({:error, 1}, fn val -> send(self(), {:called_with, val}) end)

      assert value == 1
      assert_received {:called_with, 1}
    end

    test("it does not invoke the function if result is :ok") do
      Result.tap_error({:ok, :cool}, fn _ -> send(self(), :nope) end)
      refute_received :nope
    end
  end

  describe("Result.error?/1") do
    test("returns true if result is of error type or false if ok") do
      assert Result.error?({:error, :failed})
      refute Result.error?({:ok, :cool})
    end
  end
end
