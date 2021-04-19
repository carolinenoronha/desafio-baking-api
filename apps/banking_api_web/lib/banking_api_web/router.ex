defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/accounts/:account_id/withdraw", AccountsController, :withdraw
    #post "/accounts/:account_id/transfer", AccountsController, :transfer

  end
end
