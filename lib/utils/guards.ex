defmodule Utils.Guards do
  defguard is_blank(value) when is_nil(value) or value == ""
end
