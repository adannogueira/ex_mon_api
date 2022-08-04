defmodule ExMonApi.Trainer.GetTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer
  alias Trainer.{Get, Create}

  describe "call/1" do
    test "returns a trainer on success" do
      {:ok, %{id: trainer_id}} = Create.call(%{name: "Adan", password: "12345678"})

      assert {:ok, trainer} = Get.call(trainer_id)
      assert %Trainer{name: "Adan", id: ^trainer_id} = trainer
    end

    test "returns not found error when the trainer doesn't exist" do
      assert {:error, reason} = Get.call(Ecto.UUID.generate())
      assert %{message: "Trainer not found!", status: 404} = reason
    end

    test "returns an error when id is in wrong format" do
      assert {:error, reason} = Get.call("invalid_id")
      assert "Invalid ID format" = reason
    end
  end
end
