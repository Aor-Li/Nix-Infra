{ config, lib, ... }:
let
  inherit (config.flake.aor.lib) isDirectSubmodule;
  name = "feature/ai";
in
{
  flake.modules = {
    nixos.${name}.imports =
      config.flake.modules.nixos or { }
      |> lib.filterAttrs (moduleName: _: isDirectSubmodule name moduleName)
      |> builtins.attrValues;
    homeManager.${name}.imports =
      config.flake.modules.homeManager or { }
      |> lib.filterAttrs (moduleName: _: isDirectSubmodule name moduleName)
      |> builtins.attrValues;
  };
}
