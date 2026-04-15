{
  flake.aor.modules.feature.dev.langs.nix = {
    home =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.nil
          pkgs.nixfmt
          pkgs.statix
        ];
      };
  };
}
