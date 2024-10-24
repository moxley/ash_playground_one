# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :one,
  ecto_repos: [One.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :one, OneWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: OneWeb.ErrorHTML, json: OneWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: One.PubSub,
  live_view: [signing_salt: "pYcs0meO"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :one, One.Mailer, adapter: Swoosh.Adapters.Local

config :one, :ash_domains, [Helpdesk.Support, One.Domain]

config :one, One.Guardian,
  issuer: "one",
  secret_key: "MoFS8jIwG03J/qFx1Yzn+qPGA3+gh+m4SOFqVEXiHeMJm0IA9qlFsCm0GpqN1fKx"

# Libraries

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  one: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  one: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
