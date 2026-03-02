{
  flake.aor.modules.feature.dev.starship = {
    home =
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
