defmodule Fitz.Struct do
  @moduledoc """
  Documentation for Fitz.Struct.
  """

  @doc """
  Fitz.Struct.drop_assoc
  Drops Ecto Associations from struct

  """
  def drop_assoc(struct) do
    struct
    |> Map.drop([:__meta__, :__struct__])
    |> Enum.filter(fn{k, v}-> Ecto.assoc_loaded?(v) end)
    #|> Enum.into(%{})
    #|> Enum.map(fn{k, v}-> if !Ecto.assoc_loaded?(v) do {k, %{}} else {k, v} end end)
  end

  @doc """
  Fitz.Struct.drop_assoc
  Drops Ecto Associations and nil values from struct

  """
  def clean(struct) do
    struct
    |> Map.delete([:__meta__, :__struct__])
    |> Enum.filter(fn{k, v}-> Ecto.assoc_loaded?(v) && v != nil end)
  end


end
