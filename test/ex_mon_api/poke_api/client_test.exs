defmodule ExMonApi.PokeApi.ClientTest do
  use ExUnit.Case

  import Tesla.Mock

  alias ExMonApi.PokeApi.Client

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "get_pokemon/1" do
    test "should return pokemon data when the pokemon exists" do
      body = %{"name" => "pikachu", "weight" => 60, "types" => ["electric"]}
      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      {:ok, response} = Client.get_pokemon("pikachu")

      assert body == response
    end

    test "should return an error when the pokemon doesn't exist" do
      mock(fn %{method: :get, url: @base_url <> "invalid_pokemon"} ->
        %Tesla.Env{status: 404}
      end)

      {:error, response} = Client.get_pokemon("invalid_pokemon")

      assert %{message: "Pokemon not found!", status: 404} = response
    end

    test "should return an error when there's an unexpected error" do
      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        {:error, :timeout}
      end)

      {:error, response} = Client.get_pokemon("pikachu")

      assert :timeout == response
    end
  end
end
