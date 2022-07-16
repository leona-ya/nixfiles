import Config

config :pleroma, Pleroma.Web.Endpoint,
  url: [host: System.get_env("DOMAIN", "localhost"), scheme: "https", port: 443],
    http: [ip: {127, 0, 0, 1}, port: 4001]

config :pleroma, :http_security,
  enabled: false

config :pleroma, :instance,
  name: "haj social",
  email: "flossenpflege@social.haj.gf",
  notify_email: "no-reply@social.haj.gf",
  limit: 5000,
  registrations_open: false,
  invites_enabled: true,
  federating: true,
  autofollowed_nicknames: ["flossenpflege"]

config :pleroma, Pleroma.Emails.Mailer,
  enabled: true,
  adapter: Swoosh.Adapters.SMTP,
  relay: "mail.leona.is",
  port: 465,
  ssl: true,
  auth: :always

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
config :web_push_encryption, :vapid_details, subject: "mailto:flossenpflege@social.haj.gf"

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
    background: "https://social.haj.gf/static/background.jpg",
    logo: "https://social.haj.gf/static/haj-logo.svg",
    redirectRootNoLogin: "/main/public",
    collapseMessageWithSubject: true
  }

config :pleroma, :manifest,
  icons: [
    %{
      src: "/static/favicon.png",
      type: "image/png",
      sizes: "128x128"
    },
  ]

config :pleroma, :restrict_unauthenticated,
  timelines: %{local: false, federated: true}

