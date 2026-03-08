{
  flake.aor.modules.feature.desktop.apps.sunshine = {
    nixos =
      { pkgs, ... }:
      {
        services.sunshine = {
          enable = true;
        };
      };
  };
}
