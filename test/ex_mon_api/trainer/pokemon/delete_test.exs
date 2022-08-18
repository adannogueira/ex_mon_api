defmodule ExMonApi.Trainer.Pokemon.DeleteTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Trainer.Pokemon, Trainer}
  alias Pokemon.{Delete, Create}

  describe "call/1" do
    test "deletes a pokemon on success" do
      MockSetup.mock_success("pikachu")

      {:ok, %{id: trainer_id}} = Trainer.Create.call(%{name: "Adan", password: "12345678"})
      params = %{"name" => "pikachu", "nickname" => "Pikachu", "trainer_id" => trainer_id}
      {:ok, %{id: pokemon_id}} = Create.call(params)

      count_before = Repo.aggregate(Pokemon, :count)
      {:ok, pokemon} = Delete.call(pokemon_id)
      count_after = Repo.aggregate(Pokemon, :count)

      assert %Pokemon{name: "pikachu", trainer_id: ^trainer_id} = pokemon
      assert count_after < count_before

    end

    test "returns not found error when the pokemon doesn't exist" do
      assert {:error, reason} = Delete.call(Ecto.UUID.generate())
      assert %{message: "Pokemon not found!", status: 404} = reason
    end

    test "returns an error when id is in wrong format" do
      assert {:error, reason} = Delete.call("invalid_id")
      assert "Invalid ID format" = reason
    end
  end
end
