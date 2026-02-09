{ config, ... }:
let
  inherit (config.flake) aor;
in
{
  flake.aor.modules.home.role.common = {
    imports = [
      aor.modules.home.feature.nix

      config.flake.modules.homeManager."feature/sys"
      config.flake.modules.homeManager."feature/nix"

      config.flake.modules.homeManager."feature/ai"
      config.flake.modules.homeManager."feature/tui"
      config.flake.modules.homeManager."feature/gui"
      config.flake.modules.homeManager."feature/app"
      config.flake.modules.homeManager."feature/dev"
      config.flake.modules.homeManager."feature/desktop"
    ];
  };
}
