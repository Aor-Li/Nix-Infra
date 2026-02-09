{ config, ... }:
let
  flake.modules.nixos."machine/desktop" =
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
