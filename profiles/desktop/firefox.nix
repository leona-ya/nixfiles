{ lib, ... }: {
    programs.firefox = {
      enable = true;
      policies = {
        Certificates = {
          Install = [ ../../lib/leona-is-ca.crt ];
        };
        DisableTelemetry = true;
        ExtensionSettings = lib.mapAttrs (id: shortName: {
          installation_mode = "force_installed";
          install_url	= "https://addons.mozilla.org/firefox/downloads/latest/${shortName}/latest.xpi";
        }) {
          "FirefoxColor@mozilla.com" = "firefox-color";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "momentum@momentumdash.com" = "momentumdash";
          "8c0c987e-1d1c-4a3f-97b9-705e7b7dbea4" = "kagi-search-for-firefox";
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
