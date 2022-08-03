defmodule ExMonApiWeb.TrainersControllerTest do
  use ExMonApiWeb.ConnCase

  alias ExMonApi.Trainer

  describe "show/2" do
    test "when there's a trainer, returns the trainer", %{conn: conn} do
      params = %{name: "Adan", password: "12345678"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      # To test a route we use the connection (created by the ConnCase)
      response = conn
      |> get(Routes.trainers_path(conn, :show, id))
      |> json_response(:ok)

      assert %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adan"} = response
    end

    test "when there's a validation error, returns the error with status 400", %{conn: conn} do
      response = conn
      |> get(Routes.trainers_path(conn, :show, "invalid_id"))
      |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid ID format"}

      assert response == expected_response
    end

    test "when the trainer is not found, returns the error with status 404", %{conn: conn} do
      response = conn
      |> get(Routes.trainers_path(conn, :show, Ecto.UUID.generate()))
      |> json_response(:not_found)

      expected_response = %{"message" => "Trainer not found!"}

      assert response == expected_response
    end
  end
end
