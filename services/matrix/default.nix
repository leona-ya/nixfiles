{ ... }:

{
  imports = [
    ./synapse.nix
    ./sliding-sync.nix
    ./bridges.nix
  ];

  security.acme.certs."matrix.leona.is" = {
    group = "nginx";
    extraDomainNames = [
      "sliding-sync.matrix.leona.is"
    ];
  };
}
