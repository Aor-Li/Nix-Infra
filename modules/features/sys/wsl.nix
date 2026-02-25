{ inputs, ... }:
{
  flake.aor.modules.feature.sys.wsl = {
    nixos =
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

        };
      };
  };
}
