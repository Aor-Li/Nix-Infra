# This module imports the flake-parts modules
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
