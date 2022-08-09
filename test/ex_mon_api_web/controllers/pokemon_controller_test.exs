defmodule ExMonApiWeb.PokemonControllerTest do
  use ExMonApiWeb.ConnCase

  describe "show/2" do
    test "when there's a pokemon, returns the pokemon", %{conn: conn} do
      # To test a route we use the connection (created by the ConnCase)
      response = conn
      |> get(Routes.pokemon_path(conn, :show, "pikachu"))
      |> json_response(:ok)

      assert %{"id" => _id, "name" => "pikachu", "weight" => 60, "types" => ["electric"]} = response
    end

    test "when the pokemon is not found, returns the error with status 404", %{conn: conn} do
      response = conn
      |> get(Routes.pokemon_path(conn, :show, "inexistent"))
      |> json_response(:not_found)

      expected_response = %{"message" => "Pokemon not found!"}

      assert response == expected_response
    end
  end
end
