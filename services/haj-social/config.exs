import Config

config :pleroma, Pleroma.Web.Endpoint,
  url: [host: System.get_env("DOMAIN", "localhost"), scheme: "https", port: 443],
    http: [ip: {127, 0, 0, 1}, port: 4001]

config :pleroma, :instance,
  name: "haj social",
  email: "haj-social@leona.is",
  notify_email: "haj-social@leona.is",
  limit: 5000,
  registrations_open: false,
  invites_enabled: true,
  federating: false,
  autofollowed_nicknames: ["flossenpflege"]

config :pleroma, :shout,
  enabled: false

config :pleroma, Pleroma.Captcha,
  enabled: false

config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  socket_dir: "/run/postgresql",
  database: "pleroma",
  pool_size: 10

# Configure web push notifications
config :web_push_encryption, :vapid_details, subject: "mailto:haj-social@leona.is"

config :pleroma, :database, rum_enabled: false
config :pleroma, :instance, static_dir: "/var/lib/pleroma/static"
config :pleroma, Pleroma.Uploaders.Local, uploads: "/var/lib/pleroma/uploads"

config :pleroma, :mrf,
  policies: [Pleroma.Web.ActivityPub.MRF.SimplePolicy]

config :pleroma, :mrf_simple,
  reject: [
    "freespeechextremist.com",
    "gleasonator.com",
    "gab.com",
    "gab.ai",
    "spinster.xyz",
    "shitposter.club",
    "neckbeard.xyz",
    "gitmo.life",
  ]


config :pleroma, :frontend_configurations,
  pleroma_fe: %{
    theme: "haj-social",
    background: "https://haj-social.leona.is/static/background.jpg",
    logo: "https://haj-social.leona.is/static/haj-logo.svg",
    redirectRootNoLogin: "/main/public",
    collapseMessageWithSubject: true
  }

config :pleroma, :restrict_unauthenticated,
  timelines: %{local: false, federated: true}

