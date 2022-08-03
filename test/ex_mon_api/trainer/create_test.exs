defmodule ExMonApi.Trainer.CreateTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Repo, Trainer}
  alias Trainer.Create

  describe "call/1" do
    test "when all params are valid, creates a trainer" do
      params = %{name: "Adan", password: "12345678"}

      count_before = Repo.aggregate(Trainer, :count)

      response = Create.call(params)

      count_after = Repo.aggregate(Trainer, :count)

      assert {:ok, %Trainer{name: "Adan"}} = response
      assert count_after > count_before
    end

    test "when there's invalid params, returns an error" do
      params = %{name: "Adan"}

      response = Create.call(params)

      assert {:error, changeset} = response
      assert errors_on(changeset) == %{password: ["can't be blank"]}
    end
  end
end
