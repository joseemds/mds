defmodule MdsWeb.Schema.Queries.AccountsQueries do
  alias MdsWeb.Resolvers
  use Absinthe.Schema.Notation

  object :accounts_queries do
    field :users, list_of(:user) do
      resolve(&Resolvers.AccountsResolvers.list_users/3)
    end

    field :current_user, :user do
      resolve(fn _, %{context: %{current_user: current_user}} -> {:ok, current_user} end)
    end
  end
end
