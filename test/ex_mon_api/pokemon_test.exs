defmodule ExMonApi.PokemonTest do
  # Ecto supports database operations on sandbox mode! Just use the DataCase module.
  use ExMonApi.DataCase

  alias ExMonApi.Pokemon

  describe "build/1" do
    test "when all params are valid, returns a pokemon struct" do
      types = [%{"type" => %{"name" => "electric"}}]
      params = %{"id" => Ecto.UUID.generate(), "name" => "pikachu", "weight" => 60, "types" => types}

      response = Pokemon.build(params)

      assert %Pokemon{
        name: "pikachu",
        weight: 60,
        types: ["electric"]
      } = response
    end
  end
end
