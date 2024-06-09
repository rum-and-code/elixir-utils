defmodule Utils.Validation do
  @moduledoc """
  This module contains functions related to validation
  """

  @postal_code_regex ~r/^[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d$/i
  @doc """
  Validates whether a given string matches the Canada Post's addressing guidelines on postal codes.
  For more information, see: https://www.canadapost-postescanada.ca/cpc/en/support/articles/addressing-guidelines/postal-codes.page

  It does not validate whether the postal code is used in the real world. 
  The validation is case-insensitive.
  There can be spaces, dashes or nothing at all between the two groups of three characters.

  It is up to the developer to format the postal code in the desired format once the result is deemed valid. 

  Returns `true` or `false` depending on the validity of the postal code.
  """
  def postal_code(postal_code) do
    Regex.match?(
      ~r/^[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d$/i,
      postal_code
    )
  end

  def postal_code_regex, do: @postal_code_regex

  @rfc_5322 ~r/^(?:[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$/
  @doc """
  Validates whether a given string is an RFC5322-compliant email address.
  For more information, see: https://emailregex.com/.

  It does not validate whether the email address is used in the real world.

  Returns `true` or `false` depending on the validity of the email address.
  """
  def email(email) do
    Regex.match?(@rfc_5322, email)
  end

  def email_regex, do: @rfc_5322
end
