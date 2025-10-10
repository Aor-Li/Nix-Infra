{ ... }:
let
  name = "feature/sys/basic/sleep";
in
{
  flake.modules.nixos.${name} =
    { config, lib, ... }:
    {
      options.infra.${name}.mode = lib.mkOption {
        type = lib.types.enum [
          "normal"
          "never"
        ];
        default = "normal";
        description = "Sleep mode configuration";
      };

      config = lib.mkIf (config.infra.${name}.mode == "never") {
        # todo: possible solution if followed settings do not work
        # systemd.sleep.extraConfig = ''
        #   [Sleep]
        #   AllowSuspend=no
        #   AllowHibernate=no
        #   AllowSuspendThenHibernate=no
        #   AllowHybridSleep=no
        # '';

        # Also disable sleep targets
        systemd.targets = {
          sleep.enable = false;
          suspend.enable = false;
          hibernate.enable = false;
          hybrid-sleep.enable = false;
        };

        # Prevent automatic sleep on lid close (for laptops used as servers)
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
}
