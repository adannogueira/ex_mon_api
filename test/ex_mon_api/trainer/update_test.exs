defmodule ExMonApi.Trainer.UpdateTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer
  alias Trainer.{Update, Create}

  describe "call/1" do
    test "updates a trainer on success" do
      {:ok, %{id: trainer_id}} = Create.call(%{name: "Adan", password: "12345678"})

      {:ok, trainer} = Update.call(%{"id" => trainer_id, "name" => "Lighty", "password" => "12345678"})

      assert %Trainer{name: "Lighty", id: ^trainer_id} = trainer

    end

    test "returns not found error when the trainer doesn't exist" do
      assert {:error, reason} = Update.call(%{"id" => Ecto.UUID.generate()})
      assert %{message: "Trainer not found!", status: 404} = reason
    end

    test "returns an error when id is in wrong format" do
      assert {:error, reason} = Update.call(%{"id" => "invalid_id"})
      assert "Invalid ID format" = reason
    end
  end
end
