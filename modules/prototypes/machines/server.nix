{ config, ... }:
let
  flake.modules.nixos."machine/server" =
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
