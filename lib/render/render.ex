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

  def get_template(app, folder \\ nil, template) do
     path =
       if folder do
         :code.priv_dir(app) <> "/#{folder}/" <> "#{template}"
       else
         :code.priv_dir(app) <> "/#{template}"
       end
     case File.read(path) do
       {:ok, file} ->
         {:ok, file}
       {:error, :enoent} ->
         {:error, :no_file}
     end
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
