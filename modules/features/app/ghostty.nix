{
  flake.aor.modules.feature.app.ghostty = {
    nixos = { ... }: { };
    home =
      { pkgs, ... }:
      {
        programs.ghostty.enable = true;
      };
  };
}
