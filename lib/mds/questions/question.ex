defmodule Mds.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :title, :string
    field :body, :string
    field :solved, :boolean, defaults: false
    belongs_to :user, Mds.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :body, :solved])
    |> validate_required([:title, :body])
  end
end
