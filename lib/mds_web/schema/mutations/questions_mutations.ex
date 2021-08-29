defmodule MdsWeb.Schema.Mutations.QuestionsMutations do
  @moduledoc """
  Mutations to interact with users in the database
  """

  alias MdsWeb.Resolvers
  use Absinthe.Schema.Notation

  object :questions_mutations do
    @desc "Create a question based on the current user"
    field :create_question, non_null(:question) do
      arg(:question, non_null(:create_question))

      resolve(&Resolvers.QuestionsResolvers.create_question/3)
    end
  end
end
