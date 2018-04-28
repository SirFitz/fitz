defmodule Changeset do
  @moduledoc """
  Documentation for Fitz.Changeset.
  """

  @doc """
  Changeset get_changeset_errors.
  Converts the changeset errors into strings
  """
  def errors(changeset) do
    changeset.errors
    |> Enum.map(fn {k, v} -> "Parameter #{k} #{render_detail(v)}" end)
  end

  def put_permalink(changeset, title) do
    permalink = Fitz.sluggify(title)
    if !Ecto.Changeset.get_field(changeset, :permalink) do
      Ecto.Changeset.put_change(changeset, :permalink, permalink)
    else
      changeset
    end
  end

  def put_permalink(changeset) do
    base = Ecto.Changeset.get_field(changeset, :title) || Ecto.Changeset.get_field(changeset, :name) || UUID.uuid4
    permalink = Fitz.sluggify(base)
    if !Ecto.Changeset.get_field(changeset, :permalink) do
      Ecto.Changeset.put_change(changeset, :permalink, permalink)
    else
      changeset
    end
  end

  defp render_detail({message, values}) do
   Enum.reduce values, message, fn {k, v}, acc ->
     String.replace(acc, "%{#{k}}", to_string(v))
   end
  end

  defp render_detail(message) do
   message
  end

end
