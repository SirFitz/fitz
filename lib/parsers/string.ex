defmodule Fitz.String do
  @moduledoc """
  Documentation for Fitz.String.
  """

  def remove_double_quotes(string) do
    String.replace(string, ~s("), "")
  end

  def remove_single_quotes(string) do
    String.replace(string, ~s("), "")
  end

  def parse_for_html(string) do
    string
    |> String.replace(~s("), "&#34;")
    |> String.replace("'", "&#39;")
  end

  @doc """
  Fitz.String.permalink/1
  Generates permalink

  """
  def permalink(name) do
    Regex.replace(~r/[^a-zA-Z]+/, name, "-")
      |> String.downcase
      |> String.replace("--", "-")
      |> String.replace("//", "/")
  end

  @doc """
  Fitz.String.permalink/2
  Generates permalink with a given prefix

  """
  def permalink(prefix, name) do
    suffix =
      Regex.replace(~r/[^a-zA-Z]+/, name, "-")
      |> String.downcase
      |> String.replace("--", "-")
      |> String.replace("//", "/")

    prefix <> "/" <> suffix
  end

  @doc """
  String contains_all?.
  Checks to see if a string contains a list of required elements

  """
  def contains_all?(string, required) when is_list(required) do
    list =
      Enum.map(required, fn(x)->
        String.contains?(string, x)
      end)
    case Enum.member?(list, false) do
      true ->
        false
      false ->
        true
    end
  end

end
