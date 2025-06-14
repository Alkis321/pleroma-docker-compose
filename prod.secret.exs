import Mix.Config

config :pleroma, Pleroma.Repo,
  username: System.get_env("DB_USER", "pleroma"),
  password: System.get_env("DB_PASS", "awkward"),
  database: System.get_env("DB_NAME", "pleroma"),
  hostname: System.get_env("DB_HOST", "pleroma-db"),
  pool_size: 10

config :pleroma, :instance,
  name: System.get_env("INSTANCE_NAME", "Dutchman"),
  email: System.get_env("ADMIN_EMAIL", "pleroma+admin@example.com"),
  notify_email: System.get_env("NOTIFY_EMAIL", "pleroma+admin@example.com"),
  limit: 5000,
  registrations_open: true,
  federating: true,
  federation_incoming_replies_max_depth: 10

config :pleroma, :shout,
  enabled: false

config :pleroma, :frontend_configurations,
  pleroma_fe: %{
    background: "/static/background.jpg"
  }

config :web_push_encryption, :vapid_details,
  subject: "mailto:#{System.get_env("ADMIN_EMAIL", "pleroma+admin@example.com")}",


config :pleroma, Pleroma.Web.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [host: "localhost", port: 4000],
  http: [ip: {0, 0, 0, 0}, port: 4000]