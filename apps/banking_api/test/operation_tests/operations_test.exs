defmodule BankingApi.OperationsTest do
  use ExUnit.Case

  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankingApi.Repo)
  end

  test "if balance between default account and other accounts equals zero" do
    
  end


  test "if a withdraw with positive balance is ok" do
    %Operation{
      source_account_id: "6b9e09f9-e64e-4912-8c54-90790e69ab28",
      value: 20,
      type: "Withdraw"
    }
  end

  test "if a deposit is ok" do
     %Operation{
      source_account_id: "6b9e09f9-e64e-4912-8c54-90700e69aa28",
      value: 20,
      type: "Deposit"
    }
  end


  test "if a transfer with default account being a target or a source is denied" do
    %Operation{
      source_account_id: "6b9e09f9-e64e-4912-8c54-90700e69aa28",
      target_account_id: "47616e06-e26e-46a9-a9e4-ed5d04d4b129", #Default account
      value: 20,
      type: "Transfer"
    } == false
  end

end
