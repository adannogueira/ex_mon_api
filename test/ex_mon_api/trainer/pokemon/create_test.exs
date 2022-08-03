defmodule ExMonApi.Trainer.Pokemon.CreateTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Repo, Trainer, Trainer.Pokemon}
  alias Pokemon.Create

  describe "call/1" do
    test "when all params are valid, creates a pokemon" do
      {:ok, trainer} = Trainer.Create.call(%{name: "Adan", password: "12345678"})

      params = %{"name" => "pikachu", "nickname" => "Pikachu", "trainer_id" => Map.get(trainer, :id)}

      count_before = Repo.aggregate(Pokemon, :count)

      response = Create.call(params)

      count_after = Repo.aggregate(Pokemon, :count)

      assert {:ok, %Pokemon{name: "pikachu", nickname: "Pikachu"}} = response
      assert count_after > count_before
    end

    test "when the trainer doesn't exist, returns an error" do
      params = %{"name" => "Pikachu", "trainer_id" => Ecto.UUID.generate()}

      {:error, reason} = Create.call(params)

      assert %{message: "Trainer not found!", status: 404} = reason
    end
  end
end
