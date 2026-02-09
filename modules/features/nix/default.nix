{ config, ... }:
let
  inherit (config.flake) aor;

  flake.aor.modules.nixos.feature.nix = {
    imports = [
      aor.modules.nixos.feature.nix.settings
    ];
  };

  flake.aor.modules.home.feature.nix = {
    imports = [
      aor.modules.home.feature.nix.settings
    ];
  };
in
{
  inherit flake;
}
