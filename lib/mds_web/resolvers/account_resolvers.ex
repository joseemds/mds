defmodule MdsWeb.Resolvers.AccountResolvers do
  alias Mds.Accounts

  def list_users(_, _, _) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_parent, %{user: user}, _context) do
    IO.inspect(user)
    Accounts.register_user(user)
  end
end
