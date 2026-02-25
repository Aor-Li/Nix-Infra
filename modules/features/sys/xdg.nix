{
  flake.aor.modules.feature.sys.xdg = {
    home =
      { config, pkgs, ... }:
      {
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
          };
        };
      };
  };
}
