defmodule BankingApi do
  import Ecto.Query

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Repo

  @assets_account_id "47616e06-e26e-46a9-a9e4-ed5d04d4b129"

  def withdraw(source_account_id, value) do
    Repo.transaction(fn ->
      query =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^source_account_id,
          lock: "FOR UPDATE"

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

      query_asset =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^@assets_account_id,
          lock: "FOR UPDATE"

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

      Operation.changeset(%{
        type: "Withdraw",
        value: value,
        source_account_id: account.id,
        target_account_id: @assets_account_id
      })
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  # Change variables name

  def deposit(source_account_id, value) do
    Repo.transaction(fn ->
      query =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^source_account_id,
          lock: "FOR UPDATE"

      account = Repo.one(query)

      if not is_nil(account) do
        Account.changeset(account, %{balance: account.balance + value})
        |> Repo.update()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      else
        Repo.rollback(:account_not_found)
      end

      query_asset =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^@assets_account_id,
          lock: "FOR UPDATE"

      account_asset = Repo.one(query_asset)

      if not is_nil(account_asset) do
        Account.changeset(account_asset, %{balance: account_asset.balance - value})
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
        target_account_id: account.id,
        source_account_id: @assets_account_id
      })
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  #Change variables name - switch to snake case

  def transfer(source_account_id, target_account_id, value) do
    Repo.transaction(fn ->
      sourceQuery =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^source_account_id,
          lock: "FOR UPDATE"

      sourceAccount = Repo.one(sourceQuery)

      if not is_nil(sourceAccount) do
        Account.changeset(sourceAccount, %{balance: sourceAccount.balance - value})
        |> Repo.update()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end
      else
        Repo.rollback(:account_not_found)
      end

      targetQuery =
        from a in BankingApi.Accounts.Schemas.Account,
          where: a.id == ^target_account_id,
          lock: "FOR UPDATE"

      targetAccount = Repo.one(targetQuery)

      if not is_nil(targetAccount) do
        Account.changeset(targetAccount, %{balance: targetAccount.balance + value})
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
        target_account_id: targetAccount.id,
        source_account_id: sourceAccount.id
      })
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end
end
