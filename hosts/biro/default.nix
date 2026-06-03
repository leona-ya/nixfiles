{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./network.nix
    ./disko.nix
    ../../profiles/moka-libvirt
    ../../services/web
    ../../services/snipe-it
    ../../services/dns-knot/secondary
    ../../services/dns-kresd
  ];

  services.kresd.listenPlain = [
    "127.0.0.1:53"
    "[::1]:53"
    "10.151.9.1:53"
    "[fd8f:d15b:9f40:900::1]:53"
  ];

  # Secondary DNS
  services.knot.settings.server.listen = [
    "127.0.0.11@53"
    "95.217.67.8@53"
    "2a01:4f9:3a:1448:4000:b11::@53"
    "fd8f:d15b:9f40:c21::1@53"
  ];

  #l.backups.enable = true;
  l.nginx-sni-proxy = {
    enable = true;
    upstreamHosts = {
      "laurake.net.infinitespace.dev" = [
        "kb.leona.is"
        "nomsable.eu"
        "matrix.leona.is"
        "sliding-sync.matrix.leona.is"
        "md.leona.is"
        "netbox.leona.is"
        "pass.leona.is"
        "social.infinitespace.dev"
        "webirc.infinitespace.dev"
      ];
      "thia.wg.net.leona.is" = [
        "cloud.maroni.me"
        "cloud.leona.is"
        "fin.leona.is"
        "photos.leona.is"
        "yt.infinitespace.dev"
        "abs.infinitespace.dev"
      ];
      "shioto.net.infinitespace.dev" = [
        "auth.leona.is"
      ];
      "neris.net.infinitespace.dev" = [
        "auth.stag.infinitespace.dev"
        "discourse.stag.infinitespace.dev"
      ];
      "emuno.net.infinitespace.dev" = [
        "forkspace.net"
      ];
    };
  };

  l.backups.enable = true;

  system.stateVersion = "25.11";
}
