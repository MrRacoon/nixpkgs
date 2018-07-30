{ config, lib, pkgs, ... }:

with lib;

let
  configFile = "fabio.properties";
  userName = "fabio";
  cfg = config.services.fabio;
in {
  options.services.fabio = {
    enable = mkEnableOption "fabio";

    config = mkOption {
      description = "Contents of fabio configuration file.";
      default = "";
      type = types.str;
    };

    dropPrivileges = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether fabio should be run as a non-root fabio user.
      '';
    };
  };

  config = mkIf cfg.enable (
    mkMerge [{

      environment.systemPackages = [ pkgs.fabio ];

      users.users."${userName}" = {
        description = "Fabio daemon user";
        shell = "/run/current-system/sw/bin/bash";
      };

      systemd.services.fabio = {
        description = "Fabio Load Balancer";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        documentation = ["https://fabiolb.net/"];

        serviceConfig = {
          ExecStart = "@${pkgs.fabio}/bin/fabio -config-file /etc/${configFile}";
          ExecReload  = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          PermissionsStartOnly = true;
          User = if cfg.dropPrivileges then userName else null;
          Restart = "on-failure";
          TimeoutStartSec = "0";
        };

      };
    }]
  );
}
