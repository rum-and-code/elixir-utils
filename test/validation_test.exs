defmodule Utils.ValidationTest do
  use ExUnit.Case

  describe("Validation.postal_code/2") do
    test("it starts with a letter") do
      refute Utils.Validation.postal_code("1A1 1A1")
      assert Utils.Validation.postal_code("A1B 2C3")
    end

    test("it only contains alphanumeric characters") do
      refute Utils.Validation.postal_code("A1B 2C!")
    end

    test("it alternates between letters and numbers") do
      refute Utils.Validation.postal_code("123 0A0")
      refute Utils.Validation.postal_code("ABC 0A0")
      assert Utils.Validation.postal_code("A1B 2C3")
    end

    test("it does not contain the letters D, F, I, O, Q or U") do
      refute Utils.Validation.postal_code("D0F 100")
      refute Utils.Validation.postal_code("Q0U 1I0")
      assert Utils.Validation.postal_code("A1B 2C3")
    end

    test("the first position contains neither the letters W nor Z") do
      refute Utils.Validation.postal_code("W0F 100")
      refute Utils.Validation.postal_code("Z0U 100")
      assert Utils.Validation.postal_code("A1B 2C3")
    end

    test("it is exactly 6 characters long (not counting the group separator)") do
      refute Utils.Validation.postal_code("A1B 2C")
      refute Utils.Validation.postal_code("A1B 2C34")
      assert Utils.Validation.postal_code("A1B 2C3")
      assert Utils.Validation.postal_code("A1B2C3")
    end

    test("it can have a space, a dash or nothing at all between the two groups characters") do
      assert Utils.Validation.postal_code("A1B 2C3")
      assert Utils.Validation.postal_code("A1B-2C3")
      assert Utils.Validation.postal_code("A1B2C3")
    end

    test("the validation is case insensitive") do
      assert Utils.Validation.postal_code("a1b 2C3")
    end
  end
end
