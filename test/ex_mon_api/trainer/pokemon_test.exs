defmodule ExMonApi.Trainer.PokemonTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer
  alias ExMonApi.Trainer.Pokemon

  describe "changeset/1" do
    setup do
      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(%{name: "Adan", password: "12345678"})
      {:ok, trainer_id: id}
    end

    test "when all params are valid, returns a valid changeset", %{trainer_id: trainer_id} do
      params = %{
        name: "pikachu",
        nickname: "Pikachu",
        weight: 60,
        types: ["electric"],
        trainer_id: trainer_id
      }

      response = Pokemon.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 name: "pikachu",
                 nickname: "Pikachu",
                 weight: 60,
                 types: ["electric"],
                 trainer_id: ^trainer_id
               },
               valid?: true
             } = response
    end

    test "when there's invalid params, returns an invalid changeset", %{trainer_id: trainer_id} do
      params = %{
        name: "pikachu",
        nickname: "Pikachu",
        types: ["electric"],
        trainer_id: trainer_id
      }

      response = Pokemon.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 name: "pikachu",
                 nickname: "Pikachu",
                 types: ["electric"],
               },
               valid?: false
             } = response

      assert errors_on(response) == %{weight: ["can't be blank"]}
    end
  end

  describe "build/1" do
    setup do
      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(%{name: "Adan", password: "12345678"})
      {:ok, trainer_id: id}
    end

    test "when all params are valid, returns a pokemon struct", %{trainer_id: trainer_id} do
      params = %{
        name: "pikachu",
        nickname: "Pikachu",
        weight: 60,
        types: ["electric"],
        trainer_id: trainer_id
      }

      response = Pokemon.build(params)

      assert {:ok,
              %Pokemon{
                name: "pikachu",
                nickname: "Pikachu",
                weight: 60,
                types: ["electric"],
              }} = response
    end

    test "when there's invalid params, returns an error" do
      params = %{
        name: "pikachu",
        nickname: "Pikachu",
        weight: 60,
        types: ["electric"],
      }

      {:error, response} = Pokemon.build(params)

      assert %Ecto.Changeset{
               changes: %{
                nickname: "Pikachu",
                weight: 60,
                types: ["electric"],
               },
               valid?: false
             } = response

      assert errors_on(response) == %{trainer_id: ["can't be blank"]}
    end
  end
end
