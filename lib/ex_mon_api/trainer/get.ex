# Creating a Facade Design Pattern
defmodule ExMonApi.Trainer.Get do
  alias ExMonApi.{Trainer, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Trainer, uuid) do
      nil -> {:error, %{message: "Trainer not found!", status: 404}}
      trainer -> {:ok, trainer}
    end
  end
end
