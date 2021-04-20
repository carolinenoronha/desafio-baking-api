# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankingApi.Repo.insert!(%BankingApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


BankingApi.Repo.insert!(%BankingApi.Accounts.Schemas.Account{
  id: "47616e06-e26e-46a9-a9e4-ed5d04d4b129",
  balance: 0
})

