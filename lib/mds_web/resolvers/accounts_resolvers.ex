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

  def login_user(_parent, %{user: %{type: type, login: login}} = attrs, _context) do
    attrs = Map.put(attrs, type, login)

    user_changeset = Accounts.User.login_changeset(%Accounts.User{}, attrs, type)

    Accounts.authenticate_user(user_changeset)
  end

  def current_user(_parent, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end
end
