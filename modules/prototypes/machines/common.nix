{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.prototype.machine.common = {
    imports = [
      aor.modules.feature.ai.nixos
      aor.modules.feature.nix.nixos
      aor.modules.feature.dev.nixos
      aor.modules.feature.sys.nixos
      aor.modules.feature.app.nixos
      aor.modules.feature.network.nixos
      aor.modules.feature.desktop.nixos

      config.flake.modules.nixos."feature/gui"
      config.flake.modules.nixos."feature/dev"
    ];
  };
}
