{
  disabledModules = [
    "services/security/vouch-proxy.nix"
  ];
  imports = [
    ./meta
    ./backups
    ./sops
    ./vouch-proxy
    ./grocy
    ./nginx-sni-proxy
    ./imapsync
    ./ory-hydra
    ./nginx
    ./monitoring
    ./remote-unlock
  ];
}
