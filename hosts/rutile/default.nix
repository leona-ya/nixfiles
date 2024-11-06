{ inputs, pkgs, ... }: {
  imports = [
    ../../profiles/strato/x86_64
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/monitoring
#    ../../services/plausible
  ];
  
  #l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c11::1]";
    diskioDisks = [ "vda" ];
  };
  l.promtail = {
    enable = true;
    enableNginx = true;
  };

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "25.05";
}

