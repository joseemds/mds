defmodule MdsWeb.Schema do
  use Absinthe.Schema
  alias MdsWeb.Resolvers

  import_types(__MODULE__.AccountTypes)

  query do
    field :user, list_of(:user) do
      resolve(&Resolvers.AccountResolvers.list_users/3)
    end
  end

  mutation do
    @desc "Register a user"
    field :create_user, :user do
      arg(:user, non_null(:user_register))

      resolve(&Resolvers.AccountResolvers.register_user/3)
    end
  end
end
