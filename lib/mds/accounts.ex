defmodule Mds.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Mds.Repo

  alias Mds.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def register_user(attrs) do
    User.register_changeset(%User{}, attrs)
    |> Repo.insert()
  end

  def get_user_by_email(changeset) do
    email = Ecto.Changeset.get_field(changeset, :email)
    Repo.get_by(User, email: email)
  end

  def get_user_by_username(changeset) do
    username = Ecto.Changeset.get_field(changeset, :username)
    Repo.get_by(User, username: username)
  end
end
