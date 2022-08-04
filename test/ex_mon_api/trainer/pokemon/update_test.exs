defmodule ExMonApi.Trainer.Pokemon.UpdateTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Trainer.Pokemon, Trainer}
  alias Pokemon.{Update, Create}

  describe "call/1" do
    test "updates a pokemon on success" do
      {:ok, %{id: trainer_id}} = Trainer.Create.call(%{name: "Adan", password: "12345678"})
      params = %{"name" => "pikachu", "nickname" => "Pikachu", "trainer_id" => trainer_id}
      {:ok, %{id: pokemon_id}} = Create.call(params)

      {:ok, pokemon} = Update.call(%{"id" => pokemon_id, "nickname" => "Lighty"})

      assert %Pokemon{nickname: "Lighty", trainer_id: ^trainer_id} = pokemon

    end

    test "returns not found error when the pokemon doesn't exist" do
      assert {:error, reason} = Update.call(%{"id" => Ecto.UUID.generate()})
      assert %{message: "Pokemon not found!", status: 404} = reason
    end

    test "returns an error when id is in wrong format" do
      assert {:error, reason} = Update.call(%{"id" => "invalid_id"})
      assert "Invalid ID format" = reason
    end
  end
end
