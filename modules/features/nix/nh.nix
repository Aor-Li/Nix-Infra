{ config, ... }:
let
  inherit (config.flake.aor.meta) root;
in
{
  flake.aor.modules.feature.nix.nh = {
    nixos =
      { ... }:
      {
        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          flake = root;
        };
      };

    home =
      { ... }:
      {
        home.shellAliases = {
          nos = "nh os switch .";
          nhs = "nh home switch .";
        };
      };
  };
}
