{
  flake.aor.modules.feature.desktop.app.base = {
    nixos = { };
    home =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          imagemagick
        ];
      };
  };
}
