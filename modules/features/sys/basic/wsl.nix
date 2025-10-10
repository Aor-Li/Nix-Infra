{ inputs, ... }:
let
  name = "feature/sys/basic/wsl";
in
{
  flake.modules.nixos.${name} =
    { lib, hostConfig, ... }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.default
      ];

      config = lib.mkIf (hostConfig.type == "wsl") {
        wsl = {
          enable = true;
          useWindowsDriver = true;
          startMenuLaunchers = true;
          defaultUser = hostConfig.owner.username;
          wslConf.automount.root = "/mnt";
          wslConf.network.hostname = hostConfig.name;
        };

        # disable default boot
        boot.loader = {
          systemd-boot.enable = lib.mkForce false;
          efi.canTouchEfiVariables = lib.mkForce false;
        };
      };
    };
}
