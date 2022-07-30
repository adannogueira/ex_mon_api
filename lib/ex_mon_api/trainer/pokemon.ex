# To avoid confusion, this Pokemon is a trainer pokemon, so, it's associated to a trainer
defmodule ExMonApi.Trainer.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMonApi.Trainer

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "pokemon" do
    field :name, :string
    field :nickname, :string
    field :weight, :integer
    field :types, {:array, :string}
    belongs_to(:trainer, Trainer)
    timestamps()
  end

  @required_params [:name, :nickname, :weight, :types, :trainer_id]

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:trainer)
    |> validate_length(:nickname, min: 3)
  end
  def changeset(pokemon, params) do
    pokemon # The only field allowed to be updated is the nickname, so:
    |> cast(params, [:nickname])
    |> validate_required([:nickname])
    |> validate_length(:nickname, min: 3)
  end
end
