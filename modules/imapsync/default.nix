{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.imapsync;
  mailboxOpts = { name, ... }:
    {
      options = {
        host1 = mkOption {
          type = types.str;
        };
        user1 = mkOption {
          type = types.str;
        };
        passwordfile1 = mkOption {
          type = types.str;
        };
        host2 = mkOption {
          type = types.str;
          default = "localhost";
        };
        user2 = mkOption {
          type = types.str;
        };
        passwordfile2 = mkOption {
          type = types.str;
        };
        extraArgs = mkOption {
          type = types.str;
          default = "";
        };
        systemdTimerConfig = mkOption {
          type = types.attrs;
          default = {
            OnCalendar = "*:0/10";
            RandomizedDelaySec = 120;
          };
        };
      };
    };

  mkService = name: jobcfg:
    let
      cliArgs = "--nolog --host1 ${jobcfg.host1} --ssl1 --user1 ${jobcfg.user1} --passfile1 ${jobcfg.passwordfile1} --host2 ${jobcfg.host2} --ssl2 --user2 ${jobcfg.user2} --passfile2 ${jobcfg.passwordfile2} --noemailreport1 --noemailreport2 ${jobcfg.extraArgs}";
    in nameValuePair "imapsync-job-${name}" {
      description = "Imapsync job ${name}";
      serviceConfig = {
        Type = "simple";
        User = "imapsync";
        ExecStart = "${pkgs.imapsync}/bin/imapsync ${cliArgs}";
      };
    };
in {
  options.services.imapsync = mkOption {
    type = types.attrsOf (types.submodule mailboxOpts);
    default = {};
    description = "Specification of imapsync options for one or multiple sync processes";
  };
  config = mkIf (cfg != { }) ({
    users.users.imapsync = {
      description = "Imapsync Service";
      useDefaultShell = true;
      group = "imapsync";
      isSystemUser = true;
    };
    users.groups.imapsync = {};

    systemd.services = mapAttrs' mkService cfg;
    systemd.timers = mapAttrs' (name: jobcfg: nameValuePair "imapsync-job-${name}" {
      timerConfig = jobcfg.systemdTimerConfig;
      wantedBy = [ "timers.target" ];
    }) cfg;
  });
}
