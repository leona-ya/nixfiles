{ config, pkgs, ... }:

let
  udhcpcScript = pkgs.writeScript "udhcp-script"
    ''
      #! /bin/sh
      if [ "$1" = bound ]; then
        ip address add "$ip/$mask" dev "$interface"
        if [ -n "$mtu" ]; then
          ip link set mtu "$mtu" dev "$interface"
        fi
        if [ -n "$staticroutes" ]; then
          echo "$staticroutes" \
            | sed -r "s@(\S+) (\S+)@ ip route add \"\1\" via \"\2\" dev \"$interface\" ; @g" \
            | sed -r "s@ via \"0\.0\.0\.0\"@@g" \
            | /bin/sh
        fi
        if [ -n "$router" ]; then
          ip route add "$router" dev "$interface" # just in case if "$router" is not within "$ip/$mask" (e.g. Hetzner Cloud)
          ip route add default via "$router" dev "$interface"
        fi
        if [ -n "$dns" ]; then
          rm -f /etc/resolv.conf
          for server in $dns; do
            echo "nameserver $server" >> /etc/resolv.conf
          done
        fi
      fi
    '';
in {
  boot.initrd.availableKernelModules = [ "virtio_pci" ];
  boot.initrd.network = {
    enable = true;
    postCommands = ''
      ip link set "eth0" up && ifaces="$ifaces eth0"
      udhcpc --quit --now -i eth0 -O staticroutes --script ${udhcpcScript}
    '';
    ssh = {
      enable = true;
      port = 22;
      authorizedKeys = config.users.users.em0lar.openssh.authorizedKeys.keys;
      hostKeys = [ "/boot/ssh_initrd_ed25519" "/boot/ssh_initrd_rsa" ];
    };
  };
}


