{ config, lib, ... }:
let
  path = [
    "aor"
    "modules"
    "feature"
    "sys"
    "sleep"
  ];
in
{
  flake = lib.setAttrByPath path {
    nixos =
      { config, lib, ... }:
      let
        cfg = lib.getAttrFromPath path config;
      in
      {
        options = lib.setAttrByPath path {
          mode = lib.mkOption {
            type = lib.types.enum [
              "normal"
              "never"
            ];
            default = "normal";
            description = "Sleep mode configuration";
          };
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
