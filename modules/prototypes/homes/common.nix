{ config, ... }:
let
  flake.modules.homeManager."home/common" =
    { options, lib, ... }:
    {
      imports = [
        config.flake.modules.homeManager."private/system"
        config.flake.modules.homeManager."private/nix"
        config.flake.modules.homeManager."feature/basic"
        config.flake.modules.homeManager."feature/daily"
        config.flake.modules.homeManager."feature/network"
      ];
    };
in
{
  inherit flake;
}
