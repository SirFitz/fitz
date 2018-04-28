defmodule Fitz do
  @moduledoc """
  Documentation for Fitz.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Fitz.hello
      :world

  """
  def hello do
    :world
  end


  @doc """
  Fitz is_nil?
  Checks if the entity is empty or nil

  ## Examples

      iex> Fitz.is_nil?([])
      true

  """

  def is_nil?(params) do
    list = ["", nil, [], {}, %{}, '']
    if Enum.member?(list, params) do
      true
    else
      false
    end
  end

  @doc """
  Fitz slugify/1?
  Makes a slug from a string

  ## Examples

  iex> Fitz.sluggify("Apples are super tasty and fun and nice to eat, don't you think so?")
  "apples-are-super-tasty-and-fun"

  """
  def sluggify(string) do
    Slug.slugify(string, separator: ?-, truncate: 120, ignore: "/")
    |> filter_slash
  end

  @doc """
  Fitz slugify/2?
  Makes a slug from a string

  ## Examples

  iex> Fitz.sluggify("Apples are super tasty and fun and nice to eat, don't you think so?", ?_)
  "apples_are_super_tasty_and_fun"

  """
  def sluggify(string, sep) do
    Slug.slugify(string, separator: sep, truncate: 120, ignore: "/")
    |> filter_slash
  end

  def filter_slash(string) do
    string = String.replace(string, "//", "/")
    case String.starts_with?(string, "/") do
      true ->
        string
      false ->
        "/" <> string
    end
  end

  @doc """
  Fitz file_slug/1?
  Makes a slug from a filename

  ## Examples

  iex> Fitz.file_slug("the best winter picture.png")
  "the-best-winter-picture-2982982922282.png"

  """
  def file_slug(string) do
    ext = Path.extname(string)
    root = Path.rootname(string)
    unix = "#{Timex.to_gregorian_microseconds(Timex.now)}"
    new_root = Slug.slugify(root, separator: ?-, truncate: 120)
    new_root <> "_" <> unix <> ext
  end


end
