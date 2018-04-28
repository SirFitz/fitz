defmodule Render do


  @doc """
  Fitz.Render.eex
  renders an EEx template

  ## Examples
      iex> template = "The bird is <%= color %>"
      iex> EEx.eval_string(template, color: "blue")
      The bird is blue

  """
  def eex(template, data) do
    EEx.eval_string(template, data)
  end


  @doc """
  Fitz.Render.liquid
  renders a liquid template

  ## Examples
      iex > template = "The dog is {{verb}}"
      iex> EEx.eval_string(template, verb: "shaggy")
      The dog is shaggy

  """
  def liquid(template, data) do
     Liquid.Template.parse(template)
       |> Liquid.Template.render(data)
       |> elem(1)
  end

end
