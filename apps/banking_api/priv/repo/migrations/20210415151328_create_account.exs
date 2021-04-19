defmodule BankingApi.Repo.Migrations.CreateAccount do

  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :balance, :integer, default: 100_00

      timestamps()
    end

    create constraint(:accounts, :balance_must_be_positive,
    check: "balance >= 0",
    comment: "Your balance should be equal or greater than zero")

  end
end
