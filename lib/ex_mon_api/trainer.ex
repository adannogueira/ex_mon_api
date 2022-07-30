defmodule ExMonApi.Trainer do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMonApi.Trainer.Pokemon

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "trainers" do
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true # This field is not on the DB
    has_many(:pokemon, Pokemon)
    timestamps()
  end

  @required_params [:name, :password]

  # Validating the changeset before DB insertion
  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  # Defining a way to create data on the database
  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  # A new pattern to update existing information
  def changeset(trainer, params), do: create_changeset(trainer, params)

  defp create_changeset(module_or_trainer, params) do
    module_or_trainer
    |> cast(params, @required_params) # All required fields are cast into the struct
    |> validate_required(@required_params) # The fields are validated against the schema
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  # Hashing the password
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password)) # The Argon2 will add a "password_hash" to the changeset
  end

  defp put_pass_hash(changeset), do: changeset
end
