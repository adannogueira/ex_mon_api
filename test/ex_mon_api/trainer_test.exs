defmodule ExMonApi.TrainerTest do
  # Ecto supports database operations on sandbox mode! Just use the DataCase module.
  use ExMonApi.DataCase

  alias ExMonApi.Trainer

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Adan", password: "12345678"}

      response = Trainer.changeset(params)

      assert %Ecto.Changeset{
        changes: %{
          name: "Adan",
          password: "12345678"
        },
        valid?: true
      } = response
    end

    test "when there's invalid params, returns an invalid changeset" do
      params = %{password: "12345678"}

      response = Trainer.changeset(params)

      assert %Ecto.Changeset{
        changes: %{
          password: "12345678"
        },
        valid?: false
      } = response

      assert errors_on(response) == %{name: ["can't be blank"]}
    end
  end

  describe "build/1" do
    test "when all params are valid, returns a trainer struct" do
      params = %{name: "Adan", password: "12345678"}

      response = Trainer.build(params)

      assert {:ok, %Trainer{
          name: "Adan",
          password: "12345678"
        }
      } = response
    end

    test "when there's invalid params, returns an error" do
      params = %{name: "Adan"}

      {:error, response} = Trainer.build(params)

      assert %Ecto.Changeset{
        changes: %{
          name: "Adan"
        },
        valid?: false
      } = response

      assert errors_on(response) == %{password: ["can't be blank"]}
    end
  end
end
