{
  flake.aor.modules.feature.dev.helix = {
    nixos = { ... }: { };
    home =
      { pkgs, ... }:
      {
        programs.helix.enable = true;
      };
  };
}
