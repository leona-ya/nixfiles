{ ... }: {
  services.resolved.enable = false;
  services.kresd = {
    enable = true;
    extraConfig = ''
      policy.add(policy.all(
        policy.FORWARD({
          '2606:4700:4700::1111',
          '2606:4700:4700::1001',
          '2001:4860:4860::8888',
          '2001:4860:4860::8844',
          '1.1.1.1',
          '1.0.0.1',
          '8.8.8.8',
          '8.8.4.4'
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
