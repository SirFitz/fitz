defmodule FitzTest do
  use ExUnit.Case
  doctest Fitz

  test "greets the world" do
    assert Fitz.hello() == :world
  end
end
