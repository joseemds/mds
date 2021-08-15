defmodule MdsWeb.Resolvers.AccountResolvers do
  alias Mds.Accounts

  def list_users(_, _, _) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_parent, %{user: user}, _context), do: Accounts.register_user(user)

  def login_user(_parent, %{user: %{login: login, type: type, password: password}}, _context) do
    case type do
      :email ->
        Accounts.User.email_login_changeset(%Accounts.User{}, %{email: login, password: password})

      :username ->
        Accounts.User.username_login_changeset(%Accounts.User{}, %{
          username: login,
          password: password
        })
    end
  end
end
