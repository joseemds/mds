defmodule Mds.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  This module represents the schema of a user, providing changesets to
  login, register, etc
  """

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :questions, Mds.Questions.Question

    timestamps()
  end

  def login_changeset(user, attrs, :username) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_username()
    |> validate_password(hash_password: false)
    |> verify_password(login_method: :username)
  end

  def login_changeset(user, attrs, :email) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email()
    |> validate_password(hash_password: false)
    |> verify_password()
  end

  def register_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_email()
    |> validate_username()
    |> validate_password(opts)
    |> unsafe_validate_unique([:username, :email], Mds.Repo)
    |> unique_constraint([:username, :email])
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_format(:username, ~r/^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$/,
      message: "Username can only contain numbers, letters, underscore and dot"
    )
    |> validate_length(:username, max: 20)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp verify_password(changeset, opts \\ []) do
    login_method = Keyword.get(opts, :login_method, :email)

    password = get_field(changeset, :password)

    case login_method do
      :email ->
        changeset
        |> Mds.Accounts.get_user_by_email()

      :username ->
        changeset
        |> Mds.Accounts.get_user_by_username()
    end
    |> Argon2.check_pass(password)
    |> case do
      {:ok, _user} -> changeset
      {:error, reason} -> add_error(changeset, :password, reason)
    end
  end

  def data() do
    Dataloader.Ecto.new(Mds.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
