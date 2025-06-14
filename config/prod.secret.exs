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

# Fix VAPID configuration - removed trailing comma and added required keys
config :web_push_encryption, :vapid_details,
  subject: "mailto:#{System.get_env("ADMIN_EMAIL", "pleroma+admin@example.com")}",
  public_key: System.get_env("VAPID_PUBLIC_KEY", ""),
  private_key: System.get_env("VAPID_PRIVATE_KEY", "")

# Added clear_on_media_upload setting
config :pleroma, Pleroma.Upload,
  filters: [Pleroma.Upload.Filter.Dedupe],
  uploader: Pleroma.Uploaders.Local,
  base_url: "https://#{System.get_env("DOMAIN", "social.mpampis.com")}/media",
  uploads: "./uploads",
  link_name: true,
  proxy_remote: false,
  proxy_opts: [redirect_on_failure: true],
  clear_on_media_upload: true

# Updated endpoint configuration 
config :pleroma, Pleroma.Web.Endpoint,
  url: [host: System.get_env("DOMAIN", "social.mpampis.com"), scheme: "https", port: 443],
  http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT", "4000"))],
  secret_key_base: System.get_env("SECRET_KEY_BASE", "mBN26/ho5+wXpOMsRtqKrzM8el9qOeN/xoLy8SqmM/ojy7wkbzQY3UBWv2FNo87NVSs9d3M/otqyD7oJaorkPA=="),
  live_view: [signing_salt: "PleromaLiveViewSalt"]
