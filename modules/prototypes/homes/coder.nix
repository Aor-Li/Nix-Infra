{ config, ... }:
let
  flake.modules.homeManager."home/coder" =
    { ... }:
    {
      imports = [
      ];
    };
in
{
  inherit flake;
}
