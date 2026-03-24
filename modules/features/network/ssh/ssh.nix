{ config, ... }:
let
  inherit (config.flake.aor.meta) root;
in
{
  flake.aor.modules.feature.network.ssh = {
    nixos =
      { pkgs, ... }:
      {
        services.openssh.enable = true;
      };

    home =
      {
        config,
        lib,
        hostConfig,
        ...
      }:
      {
        config = lib.mkIf (hostConfig.name == "Bakotsu") {
          # [HACK] 似乎修改了ssh/config仍然避免不了屏蔽
          home.file.".ssh/config".source = ./config;
        };
      };
  };
}
