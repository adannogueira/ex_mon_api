# Creating a Facade Design Pattern
defmodule ExMonApi.Trainer.Pokemon.Get do
  alias ExMonApi.{Trainer.Pokemon, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, %{message: "Pokemon not found!", status: 404}}
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)} # To populate associations, use the Repo.preload/2
    end
  end
end
