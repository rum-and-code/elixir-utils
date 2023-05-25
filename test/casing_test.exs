defmodule Utils.CasingTest do
  use ExUnit.Case
  alias Utils.Casing

  describe("camelize/1") do
    test("it camelize a string") do
      assert Casing.camelize("foo_bar") == "fooBar"
      assert Casing.camelize("foo-bar") == "fooBar"
    end

    test("it camelize and atom") do
      assert Casing.camelize(:foo_bar) == "fooBar"
    end

    test("it camelize a string with upper case") do
      assert Casing.camelize("foo_bar", :upper) == "FooBar"
      assert Casing.camelize("foo-bar", :upper) == "FooBar"
    end
  end
end
