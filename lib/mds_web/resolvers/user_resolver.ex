defmodule MdsWeb.Resolvers.UserResolver do
  alias Mds.Accounts

  def list_users(_, _, _) do
    {:ok, Accounts.list_users()}
  end
end
