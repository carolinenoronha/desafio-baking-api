defmodule BankingApi.Accounts.Schemas.Account do
  @moduledoc """
   The entity of an account
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "accounts" do

    field :balance, :integer, read_after_writes: true

    timestamps()
  end


  def changeset(model, params) do
    model
    |> cast(params, [:id, :balance])
    |> check_constraint(:balance, name: :balance_must_be_positive)

  end

end
