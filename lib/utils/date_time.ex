defmodule Utils.DateTime do
  import Utils.Guards

  @moduledoc """
  This module contains functions related to date and time
  """

  @doc """
  Returns the current date and time in UTC, truncated to the second.
  By truncating to the second, we avoid potential issues with postgres.
  """
  def now, do: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  @doc """
  Returns the current date and time in a given timezone, truncated to the second.
  By truncating to the second, we avoid potential issues with postgres.
  """
  @spec local_now(Calendar.time_zone()) :: DateTime.t()
  def local_now(timezone) do
    DateTime.utc_now()
    |> DateTime.shift_zone!(timezone)
    |> DateTime.truncate(:second)
  end

  def today, do: local_today("UTC")

  @doc """
  Returns the current date in a given timezone.
  """
  @spec local_today(Calendar.time_zone()) :: Date.t()
  def local_today(timezone) do
    DateTime.utc_now()
    |> DateTime.shift_zone!(timezone)
    |> DateTime.to_date()
  end

  @doc """
  Returns the current date in UTC, formatted with the provided format.
  If no format is provided, the "YYYY-MM-DD" format is used by default.
  """
  @spec format_date(DateTime.t(), String.t()) :: String.t() | nil
  def format_date(date, format \\ "{YYYY}-{0M}-{0D}")

  def format_date(nil, _), do: nil
  def format_date(date, format), do: Timex.format!(date, format)

  @doc """
  Parses a date string into a DateTime struct using the provided format.
  If no format is provided, the "YYYY-MM-DD" format is used by default.
  If the date string is nil, nil is returned.

  ## Examples

    iex> Utils.DateTime.parse("2023-04-27")
    ~N[2023-04-27 00:00:00]

    iex> Utils.DateTime.parse("2023-04-27", "{YYYY}-{0M}-{0D}")
    ~N[2023-04-27 00:00:00]
  """
  @spec parse(String.t(), String.t()) :: DateTime.t() | nil
  def parse(date, format \\ "{YYYY}-{0M}-{0D}")

  def parse(date, _) when is_blank(date), do: nil
  def parse(date, format), do: Timex.parse!(date, format)

  @doc """
  Returns the number of days between two dates.
  If the :inclusive option is set to true, the number of days will include the start and end dates.
  """
  @spec days_between(DateTime.t(), DateTime.t(), Keyword.t()) :: integer()
  def days_between(from, to, opts \\ []) do
    inclusive = Keyword.get(opts, :inclusive, false)
    days_between = Timex.diff(from, to, :days)

    if inclusive, do: days_between + 1, else: days_between
  end

  @doc """
  Returns the age of a person, in years, based on their date of birth.
  """
  @spec age(DateTime.t(), DateTime.t()) :: integer()
  def age(today, date) do
    Timex.diff(today, date, :years)
  end

  @doc """
  Returns the new converted date to the given timezone offset.
  """
  @spec convert_to_timezone(DateTime.t(), integer()) :: DateTime.t()
  def convert_to_timezone(date, timezone_offset) do
    Timex.shift(date, seconds: timezone_offset)
  end
end
