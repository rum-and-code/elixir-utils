defmodule Utils.Validation do
  @moduledoc """
  This module contains functions related to validation
  """

  @doc """
  Expects a string

  Validate that the alphanumeric postal code is in the correct format and respects Canada Post rules.
  It does not validate that the postal code is used in the real world. 
  The validation is case insensitive.
  There can be spaces, dashes or nothing at all between the two groups of three characters.

  It is up to the developper to format the postal code in the desired format once the result is deemed valid. 

  Return `true` or `false` depending on the validity of the postal code.
  """
  def postal_code(postal_code) do
    Regex.match?(
      ~r/^[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d$/i,
      postal_code
    )
  end
end
