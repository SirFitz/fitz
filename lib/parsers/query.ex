defmodule Fitz.Query do
  @moduledoc """
  Documentation for Fitz.Query.
  """


  @doc """
  Fitz.Query.to_map
  Converts raw sql query to a usable map.

  """
  def to_map(result) do

    cols = Enum.map result.columns, &(String.to_atom(&1))
    roles = Enum.map result.rows, fn(row) ->
      row # c
    end

    roles = Enum.map result.rows, fn(row) ->
      Enum.zip(cols, row) # c
    end

    roles
    |> Enum.map(fn(x)->
            Enum.map(x, fn{k, v}->
                  %{Atom.to_string(k) => v}
            end)
            |> Enum.reduce(fn(x, acc)->
                   Map.merge(x, acc)
                end)
       end)

  end
end
