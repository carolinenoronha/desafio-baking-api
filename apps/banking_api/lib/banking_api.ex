defmodule BankingApi do
  import Ecto.Query

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Repo

  @assets_account_id "47616e06-e26e-46a9-a9e4-ed5d04d4b129"



  def withdraw(source_account_id, value) do

    Repo.transaction(fn ->

      query = from a in BankingApi.Accounts.Schemas.Account, where: a.id == ^source_account_id , lock: "FOR UPDATE"


      account = Repo.one(query)
      if not is_nil(account) do
      Account.changeset(account, %{balance: account.balance - value})
      |> Repo.update()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
      else
      Repo.rollback(:account_not_found)

      end


      query_asset = from a in BankingApi.Accounts.Schemas.Account, where: a.id == ^@assets_account_id, lock: "FOR UPDATE"


      account_asset = Repo.one(query_asset)
      if not is_nil(account_asset) do
      Account.changeset(account_asset, %{balance: account_asset.balance + value})
      |> Repo.update()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
      else
      Repo.rollback(:account_not_found)

      end

      Operation.changeset(%{type: "Withdraw", value: value, source_account_id: account.id, target_account_id: @assets_account_id})
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end

    end)

end


  def deposit(source_account_id, value) do
    Repo.transaction(fn ->
      deposit_query =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^source_account_id,
          lock: "FOR UPDATE"

      deposit_account = Repo.one(deposit_query)

      if not is_nil(deposit_account) do
        Account.changeset(deposit_account, %{balance: deposit_account.balance + value})
        |> Repo.update()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      else
        Repo.rollback(:account_not_found)
      end

      deposit_query_asset =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^@assets_account_id,
          lock: "FOR UPDATE"

      deposit_account_asset = Repo.one(deposit_query_asset)

      if not is_nil(deposit_account_asset) do
        Account.changeset(deposit_account_asset, %{balance: deposit_account_asset.balance - value})
        |> Repo.update()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      else
        Repo.rollback(:account_not_found)
      end

      Operation.changeset(%{
        type: "Deposit",
        value: value,
        target_account_id: deposit_account.id,
        source_account_id: @assets_account_id
      })
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end


  def transfer(source_account_id, target_account_id, value) do
    Repo.transaction(fn ->
      source_query =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^source_account_id,
          lock: "FOR UPDATE"

      source_account = Repo.one(source_query)

      if not is_nil(source_account) do
        Account.changeset(source_account, %{balance: source_account.balance - value})
        |> Repo.update()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      else
        Repo.rollback(:account_not_found)
      end

      target_query =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^target_account_id,
          lock: "FOR UPDATE"

      target_account = Repo.one(target_query)

      if not is_nil(target_account) do
        Account.changeset(target_account, %{balance: target_account.balance + value})
        |> Repo.update()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      else
        Repo.rollback(:account_not_found)
      end

      Operation.changeset(%{
        type: "Transfer",
        value: value,
        target_account_id: target_account.id,
        source_account_id: source_account.id
      })
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  def create_account do
    Repo.insert(%BankingApi.Accounts.Schemas.Account{balance: 100})

  end
end
