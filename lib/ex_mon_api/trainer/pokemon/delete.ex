defmodule ExMonApi.Trainer.Pokemon.Delete do
  alias ExMonApi.{Trainer.Pokemon, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, %{message: "Pokemon not found!", status: 404}}
      pokemon -> Repo.delete(pokemon)
    end
  end
end
