defmodule Fitz.Map do
  @moduledoc """
  Documentation for Fitz.Map.
  """

  @doc """
  Map page_params.
  Converts github style pagination params into scrivener params
  ## Examples

      iex> params = %{"per_page" => 20, "page" => 3}
       %{"per_page" => 20, "page" => 3}
      iex> Fitz.Map.page_params(params)
      %{"page_size" => 20, "page" => 3}
  """

  def scrub_get_params(conn, _opts) do
     params = conn.params |> Enum.reduce(%{}, &scrub/2 )
     %{conn | params: params}
  end

  defp scrub({k, ""}, acc) do
    Map.put(acc, k, nil)
  end

  defp scrub({k, v}, acc) do
    Map.put(acc, k, v)
  end

  def page_params(pars) do
    params = Map.new
    params =
      if pars["per_page"] && pars["per_page"] != "" do
        params
        |> Map.put("page_size", pars["per_page"])
      else
        params
      end
    params =
      if pars["page"] && pars["page"] != "" do
        params
        |> Map.put("page", pars["page"])
      else
        params
      end
  end

  @doc """
  Map drop_nil.
  Removes key value pairs where the value is nil
  ## Examples

      iex> params = %{"per_page" => 20, "page" => nil}
       %{"per_page" => 20, "page" => 3}
      iex> Fitz.Map.page_params(params)
      %{"per_page" => 20}
  """
  def drop_nil(map) do
    map
    |> Enum.filter(fn{k, v}-> v != nil end)
  end

  @doc """
  Map reduce.
  Flattens a list of maps into one map
  ## Examples

      iex> params = [%{"per_page" => 20}, %{"page" => nil}]
       [%{"per_page" => 20}, %{"page" => nil}]
      iex> Fitz.Map.reduce(params)
      %{"per_page" => 20, "page" => 3}
  """
  def reduce(map), do: flatten(map)

    @doc """
    Map flatten.
    Flattens a list of maps into one map
    ## Examples

        iex> params = [%{"per_page" => 20}, %{"page" => nil}]
         [%{"per_page" => 20}, %{"page" => nil}]
        iex> Fitz.Map.flatten(params)
        %{"per_page" => 20, "page" => 3}
    """
  def flatten(map) do
    map
    |> Enum.reduce(fn(x, acc)-> Map.merge(x, acc) end)
  end

  defp atom_to_string(nil) do nil end

  defp atom_to_string(value) do
     try do
       Atom.to_string value
     rescue
       ArgumentError -> value
     end
  end

  defp string_to_atom(nil) do nil end

  defp string_to_atom(value) do
     try do
       String.to_atom value
     rescue
       ArgumentError -> value
     end
  end

  @doc """
  Map invert.
  Reverse the key with the value of each member of the map
  ## Examples

      iex> params = %{"per_page" => 20, "page" => 3}
       %{"per_page" => 20, "page" => 3}
      iex> Fitz.Map.invert(params)
      %{20 => "per_page", 3 => "page"}
  """
  def invert(map) when is_map(map) do
     Enum.map(map, fn {k, v} -> {v, k} end) |> Map.new(fn x -> x end)
  end

  @doc """
  Map key_from_value.
  Gets the key of a given value
  ## Examples

      iex> params = %{"per_page" => 20, "page" => 3}
       %{"per_page" => 20, "page" => 3}
      iex> Fitz.Map.key_from_value(params, 3)
      "page"
  """
  def key_from_value(map, value) do
     if map do
       result = map |> Enum.find(fn {_key, val} -> val == value end)
       if result do
         result |> elem(0)
       end
     end
  end

  @doc """
  Map flatten.
  Converts atom keys to string
  ## Examples

      iex> params = %{per_page: 20, page: 3}
       %{per_page: 20, page: 3}
      iex> Fitz.Map.atom_keys_to_string(params)
      %{20 => "per_page", 3 => "page"}
  """
  def atom_keys_to_string(map) when is_map(map) do
     map = unless Map.has_key?(map, :__struct__) do
             map
           else
             map |> Map.from_struct
           end
     for {key, val} <- map, into: %{} do
       cond do
         is_binary(key) -> {key, val}
         true -> {atom_to_string(key), val}
       end
     end
  end

  def atom_keys_to_string(list) when is_list(list) do
     list
     |> Enum.map(fn(x) -> atom_keys_to_string(x) end)
  end

  @doc """
  Map flatten.
  Converts string keys to atom
  ## Examples

      iex> params = %{20 => "per_page", 3 => "page"}
       %{20 => "per_page", 3 => "page"}
      iex> Fitz.Map.string_keys_to_atom(params)
      %{per_page: 20, page: 3}
  """
  def string_keys_to_atom(map) when is_map(map) do
     map = unless Map.has_key?(map, :__struct__) do
             map
           else
             map |> Map.from_struct
           end
     for {key, val} <- map, into: %{} do
       cond do
         is_atom(key) -> {key, val}
         true -> {string_to_atom(key), val}
       end
     end
  end

  def string_keys_to_atom(list) when is_list(list) do
     list
     |> Enum.map(fn(x) -> string_keys_to_atom(x) end)
  end

  def to_atom(map) do
     newmap = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  def to_string(map) do
     newmap = for {key, val} <- map, into: %{}, do: {Atom.to_string(key), val}
  end

end
