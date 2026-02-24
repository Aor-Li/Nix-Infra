{ config, ... }:
{
  flake.aor.modules.feature.sys.sleep = {
    nixos =
      { config, lib, ... }:
      let
        cfg = config.aor.modules.feature.sys.sleep;
      in
      {
        options.aor.modules.feature.sys.sleep.mode = lib.mkOption {
          type = lib.types.enum [
            "normal"
            "never"
          ];
          default = "normal";
          description = "Sleep mode configuration";
        };

        config = lib.mkIf (cfg.mode == "never") {

          systemd.targets = {
            sleep.enable = false;
            suspend.enable = false;
            hibernate.enable = false;
            hybrid-sleep.enable = false;
          };

          services.logind = {
            lidSwitch = "ignore";
            lidSwitchExternalPower = "ignore";
            extraConfig = ''
              HandlePowerKey=ignore
              HandleSuspendKey=ignore
              HandleHibernateKey=ignore
            '';
          };

        };
      };
  };
}
