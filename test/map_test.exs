defmodule Utils.MapTest do
  use ExUnit.Case

  doctest Utils.Map

  describe("Map.trim_fields/2") do
    test("it returns a map with specified fields trimmed") do
      map = %{
        email: "wathever@something.io   ",
        password: "12345  ",
        some_atom: :wathever
      }

      assert %{map | email: String.trim(map.email)} == Utils.Map.trim_fields(map, [:email])

      assert %{map | email: String.trim(map.email), password: String.trim(map.password)} ==
               Utils.Map.trim_fields(map, [:email, :password])

      assert %{map | email: String.trim(map.email), password: String.trim(map.password)} ==
               Utils.Map.trim_fields(map, [:email, :password, :whatever])

      assert map == Utils.Map.trim_fields(map, [:some_atom])
      assert map == Utils.Map.trim_fields(map, [])
    end

    test("it can trim fields in arbitrarily nested maps") do
      map = %{
        field: "   value   ",
        nested: %{
          field: " value    "
        }
      }

      trimmed = Utils.Map.trim_fields(map, [:field, [:nested, :field]])

      assert trimmed.nested.field == "value"
    end
  end
end
