{ ... }: {
  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3030;
      auth_enabled = false;

      common = {
        instance_addr = "127.0.0.1";
      };

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };

      schema_config = {
        configs = [{
          from = "2023-07-05";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };

        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        retention_period = "744h";
      };
      
      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        retention_enabled = true;
        retention_delete_delay = "2h";
        retention_delete_worker_count = 150;
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };
  security.acme.certs."loki.int.leona.is".server = "https://acme.int.leona.is/acme/acme/directory";
  
  services.nginx.virtualHosts."loki.int.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    listenAddresses = [ "[fd8f:d15b:9f40:c10::1]" ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:3030";
      extraConfig = ''
        allow ::/8;
        deny all;
      '';
    };
    locations."= /loki/api/v1/push" = {
      proxyPass = "http://127.0.0.1:3030";
      extraConfig = ''
        allow fd8f:d15b:9f40::/48;
        allow ::/8;
        deny all;
      '';
    };
  };
}