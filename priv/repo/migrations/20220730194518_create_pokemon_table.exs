# To generate this file run: mix ecto.gen.migration create_pokemon_table
defmodule ExMonApi.Repo.Migrations.CreatePokemonTable do
  use Ecto.Migration

  def change do
    create table(:pokemon, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :nickname, :string
      add :weight, :integer
      # Since this field is an array in the DB, we must ensure the array type too
      add :types, {:array, :string}
      # For the table association, we use the references function and add the needed information, ensuring the field cannot be null
      add :trainer_id, references(:trainers, type: :uuid, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
