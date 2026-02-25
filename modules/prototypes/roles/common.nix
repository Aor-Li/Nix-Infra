{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.prototype.role.common = {
    imports = [
      aor.modules.feature.nix.home
      aor.modules.feature.dev.home
      #aor.modules.feature.sys.home
      aor.modules.feature.network.home

      config.flake.modules.homeManager."feature/sys"
      config.flake.modules.homeManager."feature/nix"

      config.flake.modules.homeManager."feature/ai"
      config.flake.modules.homeManager."feature/gui"
      config.flake.modules.homeManager."feature/app"
      config.flake.modules.homeManager."feature/dev"
      config.flake.modules.homeManager."feature/desktop"
    ];
  };
}
