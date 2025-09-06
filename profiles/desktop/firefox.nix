{ lib, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      Certificates = {
        Install = [ ../../lib/leona-is-ca.crt ];
      };
      DisableTelemetry = true;
      ExtensionSettings =
        lib.mapAttrs
          (id: shortName: {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortName}/latest.xpi";
          })
          {
            "FirefoxColor@mozilla.com" = "firefox-color";
            "uBlock0@raymondhill.net" = "ublock-origin";
            "momentum@momentumdash.com" = "momentumdash";
            "8c0c987e-1d1c-4a3f-97b9-705e7b7dbea4" = "kagi-search-for-firefox";
            "{d634138d-c276-4fc8-924b-40a0ea21d284}" = "1password-x-password-manager";
          };
      PasswordManagerEnabled = false;
      UserMessaging = {
        WhatsNew = true;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = true;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        Locked = true;
      };
      Preferences = {
        "layout.accessiblecaret.enabled" = {
          "Value" = true;
          "Status" = "default";
        };
      };
    };
  };
}
