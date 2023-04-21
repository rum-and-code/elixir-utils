defmodule Utils.Guards do
  @moduledoc """
  This module is a collection of guard clauses.
  """

  defguard is_blank(value) when is_nil(value) or value == ""
end
