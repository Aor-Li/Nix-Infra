{ config, ... }:
let
  flake.modules.homeManager."role/learner" =
    { options, lib, ... }:
    {
      imports = [
      ];
    };
in
{
  inherit flake;
}
