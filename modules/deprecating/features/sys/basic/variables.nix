# This module sets some essential system variables for global utilities.
{ ... }:
let
  name = "feature/sys/basic/variables";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
    {
      environment.variables.EDITOR = "vim";
    };
}
