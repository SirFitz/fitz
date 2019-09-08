defmodule Barcode do
  @moduledoc """
  Documentation for Barcode.
  """

  @doc """
  Barcode generate.
  returns a barcode given a value and method
  ## Examples

      iex> value = "28727827"
       "28727827"
      iex> method = 39
       "28727827"
      iex> Barcode.generate(value, method)
      %{path: "/path/to/my/barcode", token: "28727827_my_padding_here", filename: "mybarcode.png", mime_type: "image/png"}
  """
  def generate(value, method) do
    token = pad_string(value, 20)
    uid = Timex.now |> Timex.to_gregorian_microseconds
    path = "/tmp/#{uid}.png"
    barcode =
      case method do
        39 ->
          Barlix.Code39.encode!(token)
          |> Barlix.PNG.print(file: path)
        93 ->
          Barlix.Code93.encode!(token)
          |> Barlix.PNG.print(file: path)
        128 ->
          Barlix.Code128.encode!(token)
          |> Barlix.PNG.print(file: path)
      end
    %{path: path, token: token, filename: "#{uid}.png", mime_type: "image/png"}
  end

  def pad_string(string, length) do
    current_length = String.length(string)
    pad_length = length - current_length
    pad_string = String.slice(String.upcase(UUID.uuid4), 0, pad_length)
    pad_string <> string
  end

end
