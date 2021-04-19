defmodule BankingApi do

  import Ecto.Query

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Repo

  def withdraw(account_id, value) do

      Repo.transaction(fn ->

        query = from a in BankingApi.Accounts.Schemas.Account, where: a.id == ^account_id , lock: "FOR UPDATE"


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

        Operation.changeset(%{type: "Withdraw", value: value, account_id: account.id})
        |> Repo.insert()
        |> case do
          {:ok, _} -> :ok
          {:error, changeset} -> Repo.rollback(changeset)
        end

      end)

  end

  def transfer(account_id, recipient, value) do
    #Selecionar a conta remetente
    #Selecionar a conta destinatária
    #Checar se ambas existem
    #Selecionar o valor
    #Subtrair o valor da conta remetente (se possível)
    #Adicionar à conta destino

    Repo.transaction(fn ->

      query1 = from a in BankingApi.Accounts.Schemas.Account, where: a.id == ^account_id , lock: "FOR UPDATE"

      account1 = Repo.one(query1)
      if not is_nil(account1) do
      Account.changeset(account1, %{balance: account1.balance - value})
      |> Repo.update()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
      else
      Repo.rollback(:account_not_found)
      end


      query2 = from a in BankingApi.Accounts.Schemas.Account, where: a.id == ^recipient , lock: "FOR UPDATE"

      account2 = Repo.one(query2)
      if not is_nil(account2) do
      Account.changeset(account2, %{balance: account2.balance + value})
      |> Repo.update()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end
      else
      Repo.rollback(:account_not_found)
      end


      Operation.changeset(%{type: "Transfer", value: value, sender: account1.id})
      |> Repo.insert()
      |> case do
        {:ok, _} -> :ok
        {:error, changeset} -> Repo.rollback(changeset)
      end

    end)

  end

end
