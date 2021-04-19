defmodule BankingApi.Operations.Schemas.Operation do
  @moduledoc """
   The entity of an account
  """

  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "operations" do

    field :value, :integer
    field :type, :string
    belongs_to :account, BankingApi.Accounts.Schemas.Account, type: Ecto.UUID

    timestamps()
  end


  def changeset(model\\%__MODULE__{}, params) do
    model
    |> cast(params, [:id, :value, :type, :account_id])
  end
end
