defmodule MdsWeb.Schema.Mutations.AccountsMutations do
  alias MdsWeb.Resolvers
  use Absinthe.Schema.Notation

  object :accounts_mutations do
    @desc "Register a user"
    field :create_user, :user do
      arg(:user, non_null(:user_register))

      resolve(&Resolvers.AccountsResolvers.register_user/3)
    end

    field :login_user, :user do
      arg(:user, non_null(:user_login))

      resolve(&Resolvers.AccountsResolvers.login_user/3)
    end
  end
end
