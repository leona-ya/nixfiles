{ pkgs, ... }:
{
  imports = [
    ../../profiles/desktop/wezterm.nix
    ../../profiles/darwin
  ];
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
  ids.gids.nixbld = 350;
  nix = {
    settings = {
      always-allow-substitutes = true;
      substituters = [
        "https://cache.nixos.org"
        "https://s3.whq.fcio.net/hydra?priority=100"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "flyingcircus.io-1:Rr9CwiPv8cdVf3EQu633IOTb6iJKnWbVfCC8x8gVz2o="
      ];

      trusted-users = [
        "leona"
        "@admin"
      ];
    };
  };
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 3;
  };
  home-manager.users.leona = {
    home.sessionVariables = {
      BATOU_AGE_IDENTITIES = "~/.ssh/fcio_age";
      BATOU_AGE_IDENTITY_PASSPHRASE = "op://Private/SSH Key Age/password";
    };
    home.sessionVariablesExtra = ''
      export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    '';
    programs.git = {
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnfB0kjcnCDFWSqSNoJcmIVWijOfGO5zGwXcxopdGU5";
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      settings = {
        user.email = "lm@flyingcircus.io";
      };
    };
    programs.jujutsu.settings = {
      user.email = "lm@flyingcircus.io";
      signing = {
        backend = "ssh";
        backends.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnfB0kjcnCDFWSqSNoJcmIVWijOfGO5zGwXcxopdGU5";
      };
    };
    programs.ssh = {
      settings."*".IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      settings."*.net.leona.is".IdentityAgent = "/Users/leona/.gnupg/S.gpg-agent.ssh";
      settings."*.wg.net.leona.is".IdentityAgent = "/Users/leona/.gnupg/S.gpg-agent.ssh";
      settings."forkspace.net".IdentityAgent = "/Users/leona/.gnupg/S.gpg-agent.ssh";
    };
  };
}
