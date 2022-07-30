defmodule ExMonApi.Trainer.Pokemon.Create do
  alias ExMonApi.PokeApi.Client
  alias ExMonApi.Trainer.Pokemon, as: TrainerPokemon
  alias ExMonApi.{Pokemon, Trainer}
  alias ExMonApi.Repo

  def call(%{"name" => name, "trainer_id" => trainer_id} = params) do
    case Repo.get(Trainer, trainer_id) do
      nil -> handle_response({:error, %{message: "Trainer not found!", status: 404}}, params)
      _trainer -> Client.get_pokemon(name)
                  |> handle_response(params)
    end
  end

  defp handle_response({:error, _message} = error, _params), do: error
  defp handle_response({:ok, body}, params) do
    body
    |> Pokemon.build()
    |> create_pokemon(params)
  end

  defp create_pokemon(%Pokemon{name: name, weight: weight, types: types}, %{
         "nickname" => nickname,
         "trainer_id" => trainer_id
       }) do
    params = %{
      name: name,
      weight: weight,
      types: types,
      nickname: nickname,
      trainer_id: trainer_id
    }

    params
    |> TrainerPokemon.build()
    |> handle_build()
  end

  defp handle_build({:ok, pokemon}), do: Repo.insert(pokemon)
  defp handle_build({:error, _changeset} = error), do: error
end
