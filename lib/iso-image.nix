{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:

let
  nixos = import (nixpkgs + "/nixos") {
    configuration = { lib, pkgs, ... }: {
      imports = [
        (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
      ];
      boot.kernelParams = [
        "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
      ];
      services.openssh.enable = true;
      networking.hostName = "iso";
      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9nTU+lsrfp+uLo1IvMEIi64m6ke0FmfZ6FxBgmKXp leona@leona.is"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkvy9P1Qweq1kykgn3IWIBWe/v/dTNAx+hd9i2aKe1O openpgp:0xCACA6CB6"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR9Kp84lHQRnaWU6gd8MHppZD3pQCI2TCeGF/kHm/A/kqADWqtTWjnD5ad1ZhOTSThCF35VGH3ICdnSCHh0uAHV7eK3GDjhxdrIJHY/WiubEpQJcS5OX/qTEn6QrPDIAZy2ykdHX7XrNWDGOlxpTjkPpHJmmDIQTZn/mMADuhVhIm03aFyVbUxpHSU+v7N8yxV5RehIw0RTy+qSjWcthDgTGPjPk1a2sElNVbsgF4VhqpdUfzG0BQCqr+zPDbeH66+gumDPXC5Pw4NQB596UWPDKaQv7juzveiPTpIjhTfpoWBjCmexGPbSYecXNee61NXe6HsGrGLtw/pRLEYVYH0ecU/b0A7TGd2gznKBgvk8xXoxkqHbDPoCPqC3moPD3BwCXTGNi6DBDAquC/Ho266AgZ+z83mP7TuDJmZ/F4f/glbb2hdZ6ITDS7Dvd+jGlw6UXlKeZThHOy+B1c9at4FeyQs6JBd4P5RwekUCF45gk0RfRu1+HE3YOXbN1s1DRXJs689DaBzTbD9rhROEjZgNT/m0VxC6w2i6WRvxcEvy+wL4HyJxdSK0MMVhZJza4MOB7qLvIq8z3L9kLDrKh6R49m+LsH7NCS9gh0wAH17E2cImSoX4IiRemn39oKZTplAwvvaGNXOmH/SqeZlGpYOL9Yn9nE5mC10/5In/KIZMQ== openpgp:0xF5B75815"
      ];
      networking.useDHCP = true;
    };
  };

in nixos.config.system.build.isoImage
