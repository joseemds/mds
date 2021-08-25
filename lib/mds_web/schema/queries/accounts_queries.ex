defmodule MdsWeb.Schema.Queries.AccountsQueries do
  @moduledoc """
  Queries for fetching user data from database
  """

  alias MdsWeb.Resolvers
  use Absinthe.Schema.Notation

  object :accounts_queries do
    field :users, list_of(:user) do
      resolve(&Resolvers.AccountsResolvers.list_users/3)
    end

    field :current_user, :user do
      middleware MdsWeb.Middlewares.Authentication
      resolve(fn _, %{context: %{current_user: current_user}} -> {:ok, current_user} end)
    end
  end
end
