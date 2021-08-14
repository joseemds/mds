defmodule MdsWeb.Schema do
  use Absinthe.Schema
  alias MdsWeb.Resolvers

  import_types(__MODULE__.AccountTypes)

  query do
    field :user, list_of(:user) do
      resolve(&Resolvers.UserResolver.list_users/3)
    end
  end
end
