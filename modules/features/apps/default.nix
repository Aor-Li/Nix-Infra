{ config, lib, ... }:
let
  name = "feature/daily";
in
{
  flake.modules = {
    nixos.${name}.imports =
      config.flake.modules.nixos or { }
      |> lib.filterAttrs (moduleName: _: lib.hasPrefix "${name}/" moduleName)
      |> builtins.attrValues;
    homeManager.${name}.imports =
      config.flake.modules.homeManager or { }
      |> lib.filterAttrs (moduleName: _: lib.hasPrefix "${name}/" moduleName)
      |> builtins.attrValues;
  };
}
