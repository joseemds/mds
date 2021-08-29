defmodule MdsWeb.Resolvers.QuestionsResolvers do
  @moduledoc """
  Resolvers for handling with users queries or mutations
  """
  alias Mds.Questions.Question

  def create_question(_parent, %{question: attrs}, %{context: %{current_user: current_user}}) do
    Question.changeset(%Question{}, attrs)
    |> Ecto.Changeset.put_assoc(:user, current_user)
    |> Mds.Repo.insert()
  end
end
