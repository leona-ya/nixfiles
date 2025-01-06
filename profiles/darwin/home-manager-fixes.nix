{ inputs, lib, pkgs, config, ... }: let
  hm = inputs.home-manager;
in {
  # from https://github.com/Atemu/home-manager/blob/darwin-copy-apps-fully-wip/modules/targets/darwin.nix
  # for some reason this requires to re-log the user every single time
  home-manager.users.leona = { config, ... }@hm: {
    home.activation = let
      appEnv = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in {
      # Can't inline this as `activation.darwinApps`, mkIf with false predicate would
      # try to set darwinApps.data which HM sees as setting a non-existant option
      darwinApps = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
        # Install MacOS applications to the user environment.
        HM_APPS="$HOME/Applications/Home Manager Apps"
        # Reset current state
        [ -e "$HM_APPS" ] && $DRY_RUN_CMD rm -r "$HM_APPS"
        $DRY_RUN_CMD mkdir -p "$HM_APPS"
        # .app dirs need to be actual directories for Finder to detect them as Apps.
        # In the env of Apps we build, the .apps are symlinks. We pass all of them as
        # arguments to cp and make it dereference those using -H
        $DRY_RUN_CMD cp --archive -H --dereference ${appEnv}/Applications/* "$HM_APPS"
        $DRY_RUN_CMD chmod +w -R "$HM_APPS"
      '';
    };
  };
}
