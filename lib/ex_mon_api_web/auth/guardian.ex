defmodule ExMonApiWeb.Auth.Guardian do
  use Guardian, otp_app: :ex_mon_api

  alias ExMonApi.{Repo, Trainer}
  alias Ecto.UUID

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = ExMonApi.fetch_trainer(id)
    {:ok,  resource}
  end

  def authenticate(%{"id" => trainer_id, "password" => password}) do
    case UUID.cast(trainer_id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> get(uuid, password)
    end
  end

  defp get(trainer_id, password) do
    case Repo.get(Trainer, trainer_id) do
      nil -> {:error, %{message: "Trainer not found!", status: 404}}
      trainer -> validate_password(trainer, password)
    end
  end

  def validate_password(%Trainer{password_hash: hash} = trainer, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(trainer)
      false -> {:error, %{message: "Unauthorized!", status: 401}}
    end
  end

  defp create_token(trainer) do
    {:ok, token, _claims} = encode_and_sign(trainer)
    {:ok, token}
  end
end
