defmodule ExMonApi.Trainer.Pokemon.GetTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Trainer.Pokemon, Trainer}
  alias Pokemon.{Get, Create}

  describe "call/1" do
    test "returns a pokemon on success" do
      {:ok, %{id: trainer_id}} = Trainer.Create.call(%{name: "Adan", password: "12345678"})
      params = %{"name" => "pikachu", "nickname" => "Pikachu", "trainer_id" => trainer_id}
      {:ok, %{id: pokemon_id}} = Create.call(params)

      assert {:ok, pokemon} = Get.call(pokemon_id)
      assert %Pokemon{name: "pikachu", trainer_id: ^trainer_id} = pokemon
    end

    test "returns not found error when the pokemon doesn't exist" do
      assert {:error, reason} = Get.call(Ecto.UUID.generate())
      assert %{message: "Pokemon not found!", status: 404} = reason
    end

    test "returns an error when id is in wrong format" do
      assert {:error, reason} = Get.call("invalid_id")
      assert "Invalid ID format" = reason
    end
  end
end
