defmodule MdsWeb.Schema do
  use Absinthe.Schema
  alias __MODULE__.Types
  alias __MODULE__.Queries
  alias __MODULE__.Mutations

  import_types(Types.AccountsTypes)
  import_types(Queries.AccountsQueries)
  import_types(Mutations.AccountsMutations)

  query do
    import_fields(:accounts_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
  end
end
