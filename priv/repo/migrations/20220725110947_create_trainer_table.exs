defmodule ExMonApi.Repo.Migrations.CreateTrainerTable do
  use Ecto.Migration

  def change do
    # By default, the primary key is an integer, below we set it false to create an uuid key
    create table(:trainers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :password_hash, :string
      timestamps()
    end
  end
end
