# Creating a Facade Design Pattern
defmodule ExMonApi.Trainer.Delete do
  alias ExMonApi.{Trainer, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case Repo.get(Trainer, uuid) do
      nil -> {:error, %{message: "Trainer not found!", status: 404}}
      trainer -> Repo.delete(trainer)
    end
  end
end
