{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.prototype.role.common = {
    imports = [
      aor.modules.feature.ai.home
      aor.modules.feature.nix.home
      aor.modules.feature.dev.home
      aor.modules.feature.sys.home
      aor.modules.feature.network.home
      aor.modules.feature.desktop.home

      config.flake.modules.homeManager."feature/gui"
      config.flake.modules.homeManager."feature/dev"
    ];
  };
}
