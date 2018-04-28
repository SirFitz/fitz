defmodule Fitz.Time do
  @moduledoc """
  Documentation for Fitz.Time.
  """

  @doc """
  Fitz.Time.stamps
  Adds Timestamps to a map for insert_all

  ## Examples
      iex> map = Map.new
      iex> Fitz.Time.stamps(map)
      %{inserted_at: #DateTime<2018-04-20 03:55:27.775326Z>,
        updated_at: #DateTime<2018-04-20 03:55:27.775326Z>}

  """
  def stamps(map) do
    time = DateTime.utc_now
    map
    |> Map.put(:inserted_at, time)
    |> Map.put(:updated_at, time)
  end

  @doc """
  Fitz.Time.date_converter
  Converts Naive DateTime to string

  ## Examples
      iex> Fitz.Time.date_converter(DateTime.utc_now)
      "August 12, 2018"

  """
  def date_converter(date) do
    date_string = date |> DateTime.to_string
    month = date_string |> String.split("-") |> Enum.at(1) |> String.to_integer |> Timex.month_name
    day = date_string |> String.split(["-", " "]) |> Enum.at(2)
    year = date_string |> String.split(["-", " "]) |> Enum.at(0)
    hour = date_string |> String.split(["-", " ", "."]) |> Enum.at(3) |> String.split(":") |> Enum.at(0) |> String.to_integer
    minute = date_string |> String.split(["-", " ", "."]) |> Enum.at(3) |> String.split(":") |> Enum.at(1)
    if hour > 12 do
      hour = hour - 12
      time = ([hour, minute] |> Enum.join(":")) <> "pm"
    else
      time = ([hour, minute] |> Enum.join(":")) <> "am"
    end
    date = month <> " " <> day <> ", " <> year
  end

  @doc """
  Fitz.Time.from_standard
  Converts a time string to an {hour, minute} tuple.

  ## Examples
      iex> Fitz.Time.from_standard("5:22PM")
      {17, 22}

  """
  def from_standard(time) do
      hours = String.split(time, ":") |> Enum.at(0) |> String.to_integer
      minutes = String.split(time, ":") |> Enum.at(1) |> String.slice(0, 2) |> String.to_integer
      tod = String.split(time, ":") |> Enum.at(1) |> String.slice(2, 4)
      if tod == "PM" do
        hours = hours + 12
      end
      time = {hours, minutes}
  end

  def timezone_converter(datetime, timezone) do
    ntz = Timex.Timezone.get(timezone)
    datetime = datetime |> Timex.to_datetime
    offset = Timex.Timezone.total_offset(ntz) /60 /60
    hours = offset
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    minutes = ( hours - offset ) * 60 + 0.0
            |> Float.round
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    #converts integer to float, or keeps existing float, we need a float to convert properly to an integer/whole number for the shift function
    time = Timex.shift(datetime, hours: -(hours), minutes: minutes)
  end

  def timezone_reconverter(datetime, timezone) do
    ntz = Timex.Timezone.get(timezone)
    datetime = datetime |> Timex.to_datetime
    offset = Timex.Timezone.total_offset(ntz) /60 /60
    hours = offset
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    minutes = ( hours - offset ) * 60 + 0.0
            |> Float.round
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    #converts integer to float, or keeps existing float, we need a float to convert properly to an integer/whole number for the shift function
    time = Timex.shift(datetime, hours: (hours), minutes: minutes)
  end

end
