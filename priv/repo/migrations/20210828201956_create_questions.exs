defmodule Mds.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :body, :string
      add :solved, :boolean
      add :user_id, references(:users)
      timestamps()
    end
  end
end
