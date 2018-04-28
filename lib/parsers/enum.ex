defmodule Fitz.Enum do
  @moduledoc """
  Documentation for Fitz.Enum.
  """

  @doc """
  Enum add index.
  Adds an index to a list and converts it to a map
  ## Examples

      iex> params = [1,2,3,4,5]
       [1,2,3,4,5]
      iex> Fitz.Enum.add_index(params)
      {0 => 1, 1 => 2, 2 => 3, 3 => 4, 4 => 5}
  """

  def add_index(enum) do
    enum
    |> Enum.with_index
    |> Enum.map(fn{k, v}->
      %{k => v}
      end)
    |> Fitz.Map.flatten
  end

  @doc """
  Enum add index.
  Zips a list of lists and converts the results the lists
  ## Examples

      iex> params = [[1,2,3,4,5],[1,2,3,4,5],[1,2,3,4,5]]
       [[1,2,3,4,5],[1,2,3,4,5],[1,2,3,4,5]]
      iex> Fitz.Enum.zip(params)
      [[1, 1, 1], [2, 2, 2], [3, 3, 3], [4, 4, 4], [5, 5, 5]]
  """

  def zip(list) do
    List.zip(list)
    |> Enum.map(fn(x)-> Tuple.to_list(x) end)
  end

  @doc """
  Enum add index.
  Gets all the keys from a list of hashes [maps/keywords_lists]
  ## Examples

      iex> params = [%{"per_page" => 20, "page_weight" => 50}, %{"page" => 3, "page_weight" => 90}]
       [%{"per_page" => 20, "page_weight" => 50}, %{"page" => 3, "page_weight" => 90}]
      iex> Fitz.Enum.all_keys(params)
      ["per_page", "page_weight", "page"]
  """

  def all_keys(list) do
    list
    |> Enum.map(fn(x)->
        if is_list(x) do
          Keyword.keys(x)
        else
          Map.keys(x)
        end
      end)
    |> List.flatten
    |> Enum.uniq
  end

end
