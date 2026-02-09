{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.nixos.machine.common = {
    imports = [
      aor.modules.nixos.feature.nix

      config.flake.modules.nixos."feature/sys"
      config.flake.modules.nixos."feature/nix"
      config.flake.modules.nixos."feature/tui"
      config.flake.modules.nixos."feature/gui"
      config.flake.modules.nixos."feature/app"
      config.flake.modules.nixos."feature/dev"
      config.flake.modules.nixos."feature/desktop"
    ];
  };
}
