defmodule ExMonApi.Pokemon.GetTest do
  use ExMonApi.DataCase

  alias ExMonApi.Pokemon
  alias Pokemon.Get

  describe "call/1" do
    test "returns a pokemon on success" do
      assert {:ok, pokemon} = Get.call("pikachu")
      assert %Pokemon{name: "pikachu", weight: 60, types: ["electric"]} = pokemon
    end

    test "returns an error on fail" do
      assert {:error, reason} = Get.call("invalid_pokemon")
      assert %{message: "Pokemon not found!", status: 404} = reason
    end
  end
end
