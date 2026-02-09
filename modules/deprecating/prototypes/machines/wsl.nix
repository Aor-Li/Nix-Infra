{ config, ... }:
let
  flake.modules.nixos."machine/wsl" =
    { hostConfig, ... }:
    {
      imports = [
        config.flake.modules.nixos."machine/common"
      ];
    };
in
{
  inherit flake;
}
