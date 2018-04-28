defmodule Validate do
  @moduledoc """
  Documentation for Fitz.Validator.
  """

  @doc """
  Validate email.
  Validates an email address
  ## Examples

      iex> email = "crystal@gmial.com"
       "crystal@gmial.com"
      iex> Fitz.Validate.email(email)
      true
      iex>
      nil
      iex> email = "crystalgmial.com"
       "crystalgmial.com"
      iex> Fitz.Validate.email(email)
      false
  """

  def email(email) do
    Regex.match?(~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, email)
  end

  @doc """
  Validate password.
  Validates a password
  ## Examples

      iex> required = ["#", "@", "3"]
       ["#", "@", "3"]
      iex> Fitz.Validate.password("applesauve@as3", 9, required)
      false
  """
  def password(password, length, required) when is_list(required) do
    with true <- String.length(password) >= length,
         true <-  Fitz.String.contains_all?(password, required)
    do
      true
    else
      # nil -> {:error, ...} an example that we can match here too
      err -> false
    end
  end


end
