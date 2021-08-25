defmodule MdsWeb.Resolvers.AccountsResolvers do
  @moduledoc """
  Resolvers for handling with users queries or mutations
  """
  alias Mds.Accounts

  def list_users(_, _, _) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_parent, %{user: user}, _context) do
    case Accounts.register_user(user) do
      {:ok, result} -> {:ok, result}
      # TODO: Handle this
      {:error, _changeset} -> {:error, message: "Something went wrong"}
    end
  end

  def login_user(_parent, %{user: %{login: login, type: type, password: password}}, _context) do
    user_changeset =
      case type do
        :email ->
          Accounts.User.email_login_changeset(%Accounts.User{}, %{
            email: login,
            password: password
          })

        :username ->
          Accounts.User.username_login_changeset(%Accounts.User{}, %{
            username: login,
            password: password
          })
      end

    Accounts.authenticate_user(user_changeset)
  end
end
