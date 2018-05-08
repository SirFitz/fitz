defmodule Fitz.URI do

  def merge_query(uri) do
    query = query(uri)
    if query do
      query = if Enum.count(query) < 2 do query ++ [%{"filter" => "true"}] else query end
      Enum.reduce(query, fn(x, acc)->
        h = "#{Map.keys(x) |> Enum.at(0)}=#{Map.values(x) |> Enum.at(0)}"
        r =
          "#{h}&#{
             if is_map(acc) do
               "#{Map.keys(acc) |> Enum.at(0)}=#{Map.values(acc) |> Enum.at(0)}"
            else
              acc
            end}"
      end)
    end
  end

  def transform(x) do
    "#{Map.keys(x) |> Enum.at(0)}=#{Map.values(x) |> Enum.at(0)}"
  end

  def query(uri) do
    if uri && is_bitstring(uri) do
      query =
          if String.contains?(uri, "?") do
            String.split(uri, "?") |> Enum.slice(1..-1) |> Enum.join
          else
            uri
          end
      String.split(query, "&")
      |> Enum.map(fn(x)->
        k = String.split(x, "=")
        %{Enum.at(k, 0) => Enum.at(k, 1)}
      end)
      |> Fitz.Map.flatten
      |> Enum.uniq_by(fn{k, _} -> k end)
      |> Enum.map(fn{k, v}-> %{k => v} end)
    else
      nil
    end
  end

  def parse(uri) do
    uri =
      URI.parse(uri)

    query_string =
      if uri.query do
        "?" <> uri.query
      else
        nil
      end

    parsed_uri =
      Map.new
      |> Map.put(:root_domain, root(uri.host))
      |> Map.put(:query_map, query(query_string))
      |> Map.put(:query_string, uri.query)
      |> Map.put(:domain, uri.authority)
      |> Map.put(:path, uri.path)
      |> Map.put(:hash, uri.fragment)
      |> Map.put(:port, uri.port)
  end

  def root(host) do
    if host do
      String.split(host, ".")
      |> Enum.slice(-2..-1)
      |> Enum.join(".")
    else
      nil
    end
  end

end
