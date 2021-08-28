defmodule MdsWeb.Schema do
  @moduledoc """
  `MdsWeb.Schema` is the entrypoint of the GraphQL application
  """

  alias Mds.Accounts.User
  alias Mds.Questions.Question

  use Absinthe.Schema
  alias __MODULE__.Types
  alias __MODULE__.Queries
  alias __MODULE__.Mutations

  import_types(Types.QuestionsTypes)

  import_types(Types.AccountsTypes)
  import_types(Queries.AccountsQueries)
  import_types(Mutations.AccountsMutations)

  query do
    import_fields(:accounts_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(User, User.data())
      |> Dataloader.add_source(Question, Question.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
