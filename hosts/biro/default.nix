{ lib, pkgs, inputs, ... }: 

{
  imports = [
    inputs.disko.nixosModules.disko
    ./network.nix
    ./disko.nix
    ../../profiles/moka-libvirt
    ../../services/web
    ../../services/snipe-it
    ../../services/dns-knot/secondary
  ];

  # Secondary DNS
  services.knot.settings.server.listen = [
    "127.0.0.11@53"
    "95.217.67.8@53"
    "2a01:4f9:3a:1448:4000:b11::@53"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.qemuGuest.enable = true;

  #l.backups.enable = true;
  l.nginx-sni-proxy = {
    enable = true;
    upstreamHosts = {
      "laurel.net.leona.is" = [
        "nomsable.eu"
        "matrix.leona.is"
        "sliding-sync.matrix.leona.is"
        "md.leona.is"
        "netbox.leona.is"
        "pass.leona.is"
        "social.infinitespace.dev"
      ];
      "thia.wg.net.leona.is" = [
        "cloud.maroni.me"
        "cloud.leona.is"
        "fin.leona.is"
        "yt.leona.is"
      ];
      "sphere.net.leona.is" = [
        "auth.leona.is"
      ];
      "naya.net.leona.is" = [
        "auth.stag.infspace.xyz"
      ];
    };
  };

  system.stateVersion = "25.11";
}
