# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phelddagrif,
  ecto_repos: [Phelddagrif.Repo]

# Configures the endpoint
config :phelddagrif, PhelddagrifWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mWmeC4Cl+XlvEnLJVUlkHlKhDr9Dp/iV7vIEg6kyusWIgL8cCWj/Ool7+WP9pjZi",
  render_errors: [view: PhelddagrifWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phelddagrif.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
