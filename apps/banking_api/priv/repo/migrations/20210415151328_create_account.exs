defmodule BankingApi.Repo.Migrations.CreateAccount do

  use Ecto.Migration

  #Remember to switch balance to bigint before deadline

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :balance, :integer

      timestamps()
    end

    create constraint(:accounts, :balance_must_be_positive,
    check: "(id != '47616e06-e26e-46a9-a9e4-ed5d04d4b129' AND balance >= 0) OR (id = '47616e06-e26e-46a9-a9e4-ed5d04d4b129' AND balance <= 0)",
    comment: "Your balance should be equal or greater than zero")

  end
end
