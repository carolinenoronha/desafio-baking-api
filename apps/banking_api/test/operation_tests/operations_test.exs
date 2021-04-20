defmodule BankingApi.OperationsTest do
  use ExUnit.Case

  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi

  test "withdraw with valid value" do
    ac = %BankingApi.Accounts.Schemas.Account{
      balance: 100
    }

    {:ok,_} = BankingApi.withdraw(1, ac)
  end

end
