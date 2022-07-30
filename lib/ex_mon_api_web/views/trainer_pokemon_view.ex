defmodule ExMonApiWeb.TrainerPokemonView do
  use ExMonApiWeb, :view

  alias ExMonApi.Trainer.Pokemon

  def render("create.json", %{
        pokemon: %Pokemon{
          id: id,
          name: name,
          inserted_at: inserted_at,
          nickname: nickname,
          types: types,
          trainer_id: trainer_id,
          weight: weight
        }
      }) do
    # The render response is going to be converted to a json
    %{
      message: "Pokemon created",
      trainer: %{
        id: id,
        name: name,
        nickname: nickname,
        types: types,
        weight: weight,
        trainer_id: trainer_id,
        inserted_at: inserted_at
      }
    }
  end

  def render("show.json", %{
        pokemon: %Pokemon{
          id: id,
          name: name,
          inserted_at: inserted_at,
          nickname: nickname,
          types: types,
          trainer: %{id: trainer_id, name: trainer_name},
          weight: weight
        }
      }) do
    %{
      trainer: %{
        id: id,
        name: name,
        nickname: nickname,
        types: types,
        weight: weight,
        trainer: %{name: trainer_name, id: trainer_id},
        inserted_at: inserted_at
      }
    }
  end

  def render("update.json", %{
        pokemon: %Pokemon{
          id: id,
          name: name,
          inserted_at: inserted_at,
          nickname: nickname,
          types: types,
          trainer_id: trainer_id,
          weight: weight
        }
      }) do
    %{
      message: "Pokemon updated",
      pokemon: %{
        id: id,
        name: name,
        nickname: nickname,
        types: types,
        weight: weight,
        trainer_id: trainer_id,
        inserted_at: inserted_at
      }
    }
  end
end
