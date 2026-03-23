{
  flake.aor.modules.feature.dev.just = {
    nixos =
      { pkgs, ... }:
      {
        systemPackages = [
          pkgs.just
        ];
      };
  };
}
