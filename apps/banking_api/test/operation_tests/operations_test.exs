defmodule BankingApi.OperationsTest do
  use ExUnit.Case

  alias BankingApi.Operations.Schemas.Operation
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi

  #Test if de balance between default account and other accounts equals zero
  #Test if a withdraw with positive balance is ok
  #Test if a deposit is ok
  #Test if a transfer with de default account being a target or a source is denied

end
