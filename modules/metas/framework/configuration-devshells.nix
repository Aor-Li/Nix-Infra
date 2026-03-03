{
  config,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = lib.mapAttrs (_: mkShell: mkShell pkgs) config.flake.aor.devShells;
    };
}
