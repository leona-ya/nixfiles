{
  config,
  pkgs,
  lib,
  ...
}:

{
  #services.shiori = {
  #  enable = true;
  #  port = 8005;
  #  address = "[::1]";
  #};
  services.nginx.virtualHosts."shiori.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://[::1]:8005";
  };

  services.postgresql = {
    ensureDatabases = [ "shiori" ];
    ensureUsers = [
      {
        name = "shiori";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.shiori = {
    description = "Shiori simple bookmarks manager";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.shiori}/bin/shiori serve --address '[::1]' --port '8005'";

      DynamicUser = true;
      StateDirectory = "shiori";
      # As the RootDirectory
      RuntimeDirectory = "shiori";

      CapabilityBoundingSet = "";
      DeviceAllow = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPriviliges = true;

      PrivateDevices = true;
      PrivateMounts = true;
      PrivateTmp = true;
      PrivateUsers = true;

      ProtectSystem = "strict";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";

      RestrictNamespaces = true;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
    environment = {
      SHIORI_DIR = "/var/lib/shiori";
      SHIORI_DATABASE_URL = "postgres://shiori@/shiori?host=/run/postgresql";
    };
  };
}
