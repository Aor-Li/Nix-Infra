{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.feature.nix = {
    nixos = {
      imports = [
        aor.modules.feature.nix.settings.nixos
      ];
    };

    home = {
      imports = [
        aor.modules.feature.nix.settings.home
      ];
    };
  };
}
