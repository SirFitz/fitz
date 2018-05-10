defmodule Qrcode do

  def generate(value, pad \\ nil) do
    token =
      case pad do
        nil ->
          pad_string(value, 20)
        pad ->
          String.upcase("#{pad}#{value}")
      end
    path = "/tmp/qr_#{token}.png"
    qrcode = :qrcode.encode(token)
    image = :qrcode_demo.simple_png_encode(qrcode)
    File.write(path, image)
    %{path: path, filename: "qr_#{token}.png", mime_type: "image/png"}
  end

  def pad_string(string, length) do
    current_length = String.length(string)
    pad_length = length - current_length
    pad_string = String.slice(String.upcase(UUID.uuid4), 0, pad_length)
    pad_string <> string
  end

end
