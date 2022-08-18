defmodule ExMonApiWeb.TrainersControllerTest do
  use ExMonApiWeb.ConnCase

  alias ExMonApi.{Trainer, Repo}

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

  describe "create/2" do
    test "when all data is correct, creates a trainer", %{conn: conn} do
      %{"trainer" => response, "message" => _message} = conn
      |> post(Routes.trainers_path(conn, :create, %{name: "Adan", password: "12345678"}))
      |> json_response(:created)

      assert %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Adan"} = response
    end
  end

  describe "delete/2" do
    test "when the trainer exist deletes it from database", %{conn: conn} do
      {:ok, %Trainer{id: trainer_id}} = ExMonApi.create_trainer(%{name: "Adan", password: "12345678"})

      count_before = Repo.aggregate(Trainer, :count)

      conn = conn
      |> delete(Routes.trainers_path(conn, :delete, trainer_id))

      count_after = Repo.aggregate(Trainer, :count)

      assert response(conn, 204)
      assert count_after < count_before
    end

    test "when the trainer is not found, returns the error with status 404", %{conn: conn} do
      response = conn
      |> delete(Routes.trainers_path(conn, :delete, Ecto.UUID.generate()))
      |> json_response(:not_found)

      assert response == %{"message" => "Trainer not found!"}
    end

    test "when there's a validation error, returns the error with status 400", %{conn: conn} do
      response =
        conn
        |> delete(Routes.trainers_path(conn, :delete, "invalid_id"))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid ID format"}

      assert response == expected_response
    end
  end

  describe "update/2" do
    test "when the trainer exists, updates it's data", %{conn: conn} do
      {:ok, %Trainer{id: trainer_id}} = ExMonApi.create_trainer(%{name: "Adan", password: "12345678"})

      %{"trainer" => response, "message" => _message} = conn
      |> put(Routes.trainers_path(conn, :update, trainer_id, %{id: trainer_id, name: "Lighty", password: "87654321"}))
      |> json_response(:ok)

      assert %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Lighty"} = response
    end

    test "when the trainer is not found, returns the error with status 404", %{conn: conn} do
      response = conn
      |> put(Routes.trainers_path(conn, :update, Ecto.UUID.generate()))
      |> json_response(:not_found)

      assert response == %{"message" => "Trainer not found!"}
    end

    test "when there's a validation error, returns the error with status 400", %{conn: conn} do
      response =
        conn
        |> put(Routes.trainers_path(conn, :update, "invalid_id"))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid ID format"}

      assert response == expected_response
    end
  end
end
