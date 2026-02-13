{ ... }:
let
  name = "feature/tui/shell/starship";
in
{
  flake.modules = {
    homeManager.${name} =
      { lib, ... }:
      {
        programs.starship = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
          settings = lib.importTOML ./catppuccin-powerline.toml;
        };
      };
  };
}
