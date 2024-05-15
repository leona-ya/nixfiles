{ pkgs, ... }: {
  systemd.services.nomsable =
    let
      configFile = pkgs.writeText "nomsable.cfg" ''
        [database]
        backend = postgresql
        name = nomsable
        host = localhost
        user = nomsable

        [general]
        static_root = /var/lib/nomsable/static
        debug = false
      '';

      pkg = pkgs.nomsable;
    in
    {
      preStart = ''
        ${pkg}/bin/manage migrate --noinput
        mkdir -p /var/lib/nomsable/static
        ${pkg}/bin/manage collectstatic --noinput --clear
      '';
      serviceConfig = {
        WorkingDirectory = "/var/lib/nomsable";
        ExecStart = ''
          ${pkgs.python3Packages.gunicorn}/bin/gunicorn nomsable.wsgi \
            --name nomsable \
            -b 127.0.0.1:9123
        '';
        StateDirectory = "nomsable";
        DyanmicUser = true;
        PrivateTmp = true;
        Restart = "on-failure";
        after = [ "postgresql.service" ];
        requires = [ "postgresql.service" ];
      };

      environment = {
        PYTHONPATH = "${pkg.python.pkgs.makePythonPath pkg.propagatedBuildInputs}:${pkg}/lib/nomsable";
        NOMSABLE_CONFIG_FILE = "${configFile}";
      };

      wantedBy = [ "multi-user.target" ];
    };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nomsable" ];
    ensureUsers = [
      {
        name = "nomsable";
        ensureDBOwnership = true;
      }
    ];
  };
  services.nginx.virtualHosts."nomsable.leona.is" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:9123";
    };
    locations."/static/" = {
      alias = "/var/lib/nomsable/static/";
    };
    enableACME = true;
    forceSSL = true;
    kTLS = true;
  };
}
