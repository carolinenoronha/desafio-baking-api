defmodule BankingApi.Repo.Migrations.Operations do
  use Ecto.Migration

  def change do
    create table(:operations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :integer, null: false
      add :type, :string, null: false
      add :source_account_id, references(:accounts, type: :uuid), null: false
      add :target_account_id, references(:accounts, type: :uuid), null: false


      timestamps()
    end

  end
end
