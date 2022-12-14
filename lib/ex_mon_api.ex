defmodule ExMonApi do
  alias ExMonApi.{Trainer, Pokemon}
  alias Trainer.Pokemon, as: TrainerPokemon

  # Assigning calls to another module via defdelegate
  # ExMonApi.create_trainer(params) will call ExMonApi.Trainer.Create(params) under the hood
  defdelegate create_trainer(params), to: Trainer.Create, as: :call
  defdelegate delete_trainer(params), to: Trainer.Delete, as: :call
  defdelegate fetch_trainer(params), to: Trainer.Get, as: :call
  defdelegate update_trainer(params), to: Trainer.Update, as: :call

  defdelegate fetch_pokemon(params), to: Pokemon.Get, as: :call

  defdelegate create_trainer_pokemon(params), to: TrainerPokemon.Create, as: :call
  defdelegate delete_trainer_pokemon(params), to: TrainerPokemon.Delete, as: :call
  defdelegate fetch_trainer_pokemon(params), to: TrainerPokemon.Get, as: :call
  defdelegate update_trainer_pokemon(params), to: TrainerPokemon.Update, as: :call
end
