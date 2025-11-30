import Config

# In test we don't send emails
config :aoc, Aoc.Mailer, adapter: Swoosh.Adapters.Test

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :aoc, AocWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "B3hfj/FEWbQKqteItvnNYDTH84Sz55fRHUnB165hAJfVcghVjonIg5UGdoZhN5Ej",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false
