import Config

config :banking_api,
  ecto_repos: [BankingApi.Repo]

config :banking_api_web,
  ecto_repos: [BankingApi.Repo],
  generators: [context_app: :banking_api]

config :banking_api_web, BankingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9UmQFYYyOtwDm3V6tuDbNV7OerVsePI55iSpz/lqrSdhMdQITFDt8EDVeBdzFCw6",
  render_errors: [view: BankingApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingApi.PubSub,
  live_view: [signing_salt: "CCGDe91y"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
