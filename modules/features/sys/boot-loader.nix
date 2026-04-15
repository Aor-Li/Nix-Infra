{
  flake.aor.modules.feature.sys.boot-loader = {
    nixos =
      { lib, hostConfig, ... }:
      {
        boot.loader = lib.mkMerge [
          (
            (lib.mkIf (
              hostConfig.type == "desktop" || hostConfig.type == "laptop" || hostConfig.type == "server"
            ))
            {
              systemd-boot.enable = true;
              efi.canTouchEfiVariables = true;
            }
          )
          ((lib.mkIf (hostConfig.type == "vm" || hostConfig.type == "wsl")) {
            systemd-boot.enable = false;
            efi.canTouchEfiVariables = false;
          })
        ];
      };
  };
}
