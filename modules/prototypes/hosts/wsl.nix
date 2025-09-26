{ config, ... }:
let
  flake.modules.nixos."host/wsl" =
    { hostConfig, ... }:
    {
      imports = [
        config.flake.modules.nixos."host/common"
      ];
    };
in
{
  inherit flake;
}
