{ ... }: {
  services.resolved.enable = false;
  services.kresd = {
    enable = true;
    extraConfig = ''
    policy.add(policy.all(
      policy.FORWARD({
        '2620:fe::11',
        '2620:fe::fe:11',
        '9.9.9.11',
        '149.112.112.11'
      })
    ))
    cache.size = 100*MB
    '';
    listenPlain = [
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };
}
