defmodule ExMonApi.PokeApi.ClientTest do
  use ExMonApi.DataCase

  alias ExMonApi.PokeApi.Client

  describe "get_pokemon/1" do
    test "should return pokemon data when the pokemon exists" do
      {:ok, response} = Client.get_pokemon("pikachu")

      assert %{"name" => "pikachu", "weight" => 60} = response
    end

    test "should return an error when the pokemon doesn't exist" do
      {:error, response} = Client.get_pokemon("invalid_pokemon")

      assert %{message: "Pokemon not found!", status: 404} = response
    end
  end
end
