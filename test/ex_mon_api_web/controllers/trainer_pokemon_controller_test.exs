defmodule ExMonApiWeb.TrainerPokemonControllerTest do
  use ExMonApiWeb.ConnCase

  alias ExMonApi.Trainer
  alias Trainer.Pokemon

  describe "show/2" do
    test "when there's a pokemon, returns the pokemon", %{conn: conn} do
      params = %{name: "Adan", password: "12345678"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      {:ok, %Pokemon{id: pokemon_id}} =
        ExMonApi.create_trainer_pokemon(%{
          "name" => "pikachu",
          "trainer_id" => id,
          "nickname" => "Pikachu"
        })

      # To test a route we use the connection (created by the ConnCase)
      response =
        conn
        |> get(Routes.trainer_pokemon_path(conn, :show, pokemon_id))
        |> json_response(:ok)

      assert %{
               "trainer" => %{
                 "id" => _id,
                 "inserted_at" => _inserted_at,
                 "name" => "pikachu",
                 "nickname" => "Pikachu",
                 "trainer" => _trainer,
                 "types" => ["electric"],
                 "weight" => 60
               }
             } = response
    end

    test "when there's a validation error, returns the error with status 400", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainer_pokemon_path(conn, :show, "invalid_id"))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid ID format"}

      assert response == expected_response
    end

    test "when the pokemon is not found, returns the error with status 404", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainer_pokemon_path(conn, :show, Ecto.UUID.generate()))
        |> json_response(:not_found)

      expected_response = %{"message" => "Pokemon not found!"}

      assert response == expected_response
    end
  end

  describe "create/2" do
    test "when all data is correct, creates a pokemon", %{conn: conn} do
      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(%{name: "Adan", password: "12345678"})

      response = conn
      |> post(Routes.trainer_pokemon_path(conn, :create, %{
        "name" => "pikachu",
        "trainer_id" => id,
        "nickname" => "Pikachu"
      }))
      |> json_response(:created)

      assert %{
        "trainer" => %{
          "id" => _id,
          "inserted_at" => _inserted_at,
          "name" => "pikachu",
          "nickname" => "Pikachu",
          "trainer_id" => _trainer_id,
          "types" => ["electric"],
          "weight" => 60
        }
      } = response
    end

    test "when the trainer is not found, returns the error with status 404", %{conn: conn} do
      response = conn
      |> post(Routes.trainer_pokemon_path(conn, :create, %{
        "name" => "pikachu",
        "trainer_id" => Ecto.UUID.generate(),
        "nickname" => "Pikachu"
      }))
      |> json_response(:not_found)

      assert response == %{"message" => "Trainer not found!"}
    end

    test "when the pokemon is not found, returns the error with status 404", %{conn: conn} do
      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(%{name: "Adan", password: "12345678"})

      response = conn
      |> post(Routes.trainer_pokemon_path(conn, :create, %{
        "name" => "invalid",
        "trainer_id" => id,
        "nickname" => "Pikachu"
      }))
      |> json_response(:not_found)

      assert response == %{"message" => "Pokemon not found!"}
    end
  end

  describe "delete/2" do

  end

  describe "update/2" do
    
  end
end
