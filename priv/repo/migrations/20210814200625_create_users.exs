defmodule Mds.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create_if_not_exists unique_index(:users, [:username, :email])
  end
end
