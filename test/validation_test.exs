defmodule Utils.ValidationTest do
  use ExUnit.Case

  describe("Validation.postal_code/1") do
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

  describe "Validation.email/1" do
    test "it must be truthy for happiest path" do
      assert Utils.Validation.email("foobar@rumandcode.io")
    end

    test "it must have exactly one '@' character" do
      refute Utils.Validation.email("foobarrumandcode.io")
      refute Utils.Validation.email("foobar@rumandcode@io")
      assert Utils.Validation.email("foobar@rumandcode.io")
    end

    test "it must have a 'local part', AKA a string before the '@' symbol" do
      refute Utils.Validation.email("@rumandcode.io")
    end

    test "it must have a 'domain part', AKA a string after the '@' symbol" do
      refute Utils.Validation.email("foobar@")
    end

    test "its 'domain part' must have at least one '.'" do
      refute Utils.Validation.email("foobar@rumandcodeio")
      assert Utils.Validation.email("foobar@rumandcode.ca")
      assert Utils.Validation.email("foobar@rumandcode.qc.ca")
      assert Utils.Validation.email("foobar@rumandcode.gouv.qc.ca")
      assert Utils.Validation.email("foobar@rumandcode.ti.gouv.qc.ca")
      assert Utils.Validation.email("foobar@rumandcode.yes.this.is.still.a.valid.domain.io")
    end

    test "its 'local part' can support any alphanumeric characters" do
      assert Utils.Validation.email("abcdefghijklmnopqrstuvwxyz0123456789@rumandcode.io")
    end

    test "its 'local part' can support any upcased alpha characters" do
      assert Utils.Validation.email("ABCDEFGHIJKLMNOPQRSTUVQXYZ@rumandcode.io")
    end

    test "its 'local part' can support any of a specific handful of special characters" do
      assert Utils.Validation.email("!#$%&'*+./=?^_`{|}~-@rumandcode.io")
    end

    test "its 'domain part' can support any alphanumeric character" do
      assert Utils.Validation.email("foobar@abcdefghijklmnopqrstuvwxyz0123456789.io")
    end

    test "its 'domain part' can support any upcased alpha characters" do
      assert Utils.Validation.email("foobar@ABCDEFGHIJKLMNOPQRSTUVQXYZ.IO")
    end

    test "its 'domain part' can only support the '-' as its special character, as long as it is in between alphanumeric characters" do
      refute Utils.Validation.email("foobar@-.io")
      refute Utils.Validation.email("foobar@-rum.io")
      refute Utils.Validation.email("foobar@rum-.io")
      refute Utils.Validation.email("foobar@rum-and-.io")
      refute Utils.Validation.email("foobar@-rum-and.io")
      assert Utils.Validation.email("foobar@rum-and.io")
      assert Utils.Validation.email("foobar@rum-and-code.io")
    end

    test "the top level domain of its 'domain part' can only support the '-' character, as long as it is in between alphanumeric characters" do
      refute Utils.Validation.email("foobar@rumandcode.-")
      refute Utils.Validation.email("foobar@rumandcode.io-")
      refute Utils.Validation.email("foobar@rumandcode.-io")
      refute Utils.Validation.email("foobar@rumandcode.qc-ca-")
      refute Utils.Validation.email("foobar@rumandcode.-qc-ca")
      assert Utils.Validation.email("foobar@rumandcode.qc-ca")
      assert Utils.Validation.email("foobar@rum-and-code.gouv-qc-ca")
    end

    test "its 'domain part' can be an IP Address" do
      assert Utils.Validation.email("foobar@[127.0.0.1:587]")
    end
  end
end
