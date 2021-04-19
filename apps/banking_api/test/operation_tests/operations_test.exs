defmodule BankingApi.OperationsTest do
  use ExUnit.Case

  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi

  test "withdraw " do
    ac = %BankingApi.Accounts.Schemas.Account{
      balance: :integer
    }

    assert {:ok, _} = BankingApi.withdraw(90, ac)
  end

end
