{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.feature.nix = {
    nixos = {
      imports = [
        aor.modules.feature.nix.settings.nixos
        aor.modules.feature.nix.home-manager.nixos
      ];
    };

    home = {
      imports = [
        aor.modules.feature.nix.settings.home
        aor.modules.feature.nix.home-manager.home
      ];
    };
  };
}
