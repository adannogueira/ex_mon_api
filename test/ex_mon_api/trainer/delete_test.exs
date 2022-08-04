defmodule ExMonApi.Trainer.DeleteTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer
  alias Trainer.{Delete, Create}

  describe "call/1" do
    test "deletes a trainer on success" do
      {:ok, %{id: trainer_id}} = Create.call(%{name: "Adan", password: "12345678"})

      count_before = Repo.aggregate(Trainer, :count)
      {:ok, trainer} = Delete.call(trainer_id)
      count_after = Repo.aggregate(Trainer, :count)

      assert %Trainer{name: "Adan", id: ^trainer_id} = trainer
      assert count_after < count_before

    end

    test "returns not found error when the trainer doesn't exist" do
      assert {:error, reason} = Delete.call(Ecto.UUID.generate())
      assert %{message: "Trainer not found!", status: 404} = reason
    end

    test "returns an error when id is in wrong format" do
      assert {:error, reason} = Delete.call("invalid_id")
      assert "Invalid ID format" = reason
    end
  end
end
