defmodule Fitz.Math do

  @doc """
  Math half.

  ## Examples

      iex> Fitz.Math.half(50)
      25

  """
  def half(num) do
    Kernel.round(num/2)
  end

  @doc """
  Math third.

  ## Examples

      iex> Fitz.Math.third(30)
      10

  """
  def third(num) do
    Kernel.round(num/3)
  end

  @doc """
  Math quarter.

  ## Examples

      iex> Fitz.Math.quarter(40)
      10

  """
  def quarter(num) do
    Kernel.round(num/4)
  end

  @doc """
  Math fifth.

  ## Examples

      iex> Fitz.Math.fifth(50)
      10

  """
  def fifth(num) do
    Kernel.round(num/5)
  end

  @doc """
  Math sixth.

  ## Examples

      iex> Fitz.Math.sixth(60)
      25

  """
  def sixth(num) do
    Kernel.round(num/6)
  end

  @doc """
  Math seventh.

  ## Examples

      iex> Fitz.Math.seventh(70)
      10

  """
  def seventh(num) do
    Kernel.round(num/7)
  end

  @doc """
  Math eigth.

  ## Examples

      iex> Fitz.Math.eigth(80)
      10

  """
  def eigth(num) do
    Kernel.round(num/8)
  end

  @doc """
  Math ninth.

  ## Examples

      iex> Fitz.Math.ninth(90)
      10

  """
  def ninth(num) do
    Kernel.round(num/9)
  end

  @doc """
  Math tenth.

  ## Examples

      iex> Fitz.Math.tenth(50)
      5

  """
  def tenth(num) do
    Kernel.round(num/10)
  end

end
