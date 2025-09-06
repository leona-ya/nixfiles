{ pkgs, ... }:
{
  imports = [
    ../../profiles/desktop/wezterm.nix
    ../../profiles/darwin
  ];
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
  home-manager.users.leona = {
    home.sessionVariables = {
      BATOU_AGE_IDENTITIES = "~/.ssh/fcio_age";
      BATOU_AGE_IDENTITY_PASSPHRASE = "op://Private/SSH Key Age/password";
    };
    home.sessionVariablesExtra = ''
      export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    '';
    programs.git = {
      userEmail = "lm@flyingcircus.io";
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnfB0kjcnCDFWSqSNoJcmIVWijOfGO5zGwXcxopdGU5";
      extraConfig = {
        "gpg".format = "ssh";
        "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
    programs.jujutsu.settings = {
      user.email = "lm@flyingcircus.io";
      signing = {
        backend = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnfB0kjcnCDFWSqSNoJcmIVWijOfGO5zGwXcxopdGU5";
      };
    };
    programs.ssh = {
      extraConfig = ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
      matchBlocks."*.net.leona.is".extraOptions.IdentityAgent = "/Users/leona/.gnupg/S.gpg-agent.ssh";
      matchBlocks."forkspace.net".extraOptions.IdentityAgent = "/Users/leona/.gnupg/S.gpg-agent.ssh";
    };
  };
}
