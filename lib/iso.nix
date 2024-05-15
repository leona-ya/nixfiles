{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../profiles/base
    ../profiles/bcachefs
  ];

  boot.kernelParams = [
    "panic=30"
    "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
  networking.hostName = "iso";
  networking.domain = "leona.is";
  networking.useDHCP = lib.mkForce true;
  services.nginx.enable = false;
}
