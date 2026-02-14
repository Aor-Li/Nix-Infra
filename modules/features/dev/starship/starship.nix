{
  flake.aor.modules.feature.dev.starhip = {
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
