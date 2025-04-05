{ config, pkgs, lib, ... }: {
  l.sops.secrets."services/gitlab-runner/env" = {};
  services.gitlab-runner = {
    enable = true;
    settings.concurrent = 5;
    services = {
      # runner for building in docker via host's nix-daemon
      # nix store will be readable in runner, might be insecure
      nix = {
        # File should contain at least these two variables:
        # `CI_SERVER_URL`
        # `CI_SERVEr_TOKEN`
        authenticationTokenConfigFile = config.sops.secrets."services/gitlab-runner/env".path;
        dockerImage = "alpine";
        dockerAllowedImages = [ "alpine" ];
        dockerVolumes = [
          "/nix/store:/nix/store:ro"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
        ];
        dockerDisableCache = true;
        preBuildScript = pkgs.writeScript "setup-container" ''
          mkdir -p -m 0754 /etc/nix
          mkdir -p -m 0755 /nix/var/log/nix/drvs
          mkdir -p -m 0755 /nix/var/nix/gcroots
          mkdir -p -m 0755 /nix/var/nix/profiles
          mkdir -p -m 0755 /nix/var/nix/temproots
          mkdir -p -m 0755 /nix/var/nix/userpool
          mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
          mkdir -p -m 1777 /nix/var/nix/profiles/per-user
          mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
          mkdir -p -m 0700 "$HOME/.nix-defexpr"

          cat >/etc/nix/nix.conf <<EOL
experimental-features = nix-command flakes pipe-operators
EOL

          . ${pkgs.lix}/etc/profile.d/nix.sh

          ${pkgs.lix}/bin/nix-env -i ${lib.concatStringsSep " " (with pkgs; [ lix cacert git openssh ])}
        '';
        environmentVariables = {
          ENV = "/etc/profile";
          USER = "root";
          NIX_REMOTE = "daemon";
          PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
          NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
          NIX_PATH = "nixpkgs=channel:nixos-unstable";
        };
        tagList = [ "nix" ];
      };
    };
  };

  systemd.services.gitlab-runner.serviceConfig.Restart = "on-failure";
}


