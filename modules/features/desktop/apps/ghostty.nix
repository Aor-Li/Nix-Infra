{
  flake.aor.modules.feature.desktop.apps.ghostty = {
    nixos = { ... }: { };
    home =
      { pkgs, ... }:
      {
        programs.ghostty.enable = true;
      };
  };
}
