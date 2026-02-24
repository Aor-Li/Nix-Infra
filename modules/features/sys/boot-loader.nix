{ ... }:
{
  flake.aor.modules.feature.sys.boot-loader = {
    nixos =
      { lib, hostConfig, ... }:
      {
        boot.loader =
          lib.mkIf
            (
              !builtins.elem hostConfig.type [
                "wsl"
                "vm"
              ]
            )
            {
              systemd-boot.enable = true;
              efi.canTouchEfiVariables = true;
            };
      };
  };
}
