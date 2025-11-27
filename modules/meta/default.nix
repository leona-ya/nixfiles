{ lib, ... }: {
  options.l.meta = {
    bootstrap = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether this host currently gets bootstraped.
        This disables all secrets, as in bootstrapping no SSH hostkey exists.
      '';
    };
  };
}
