{
  flake.aor.modules.feature.nix.format = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.nixfmt
          pkgs.alejandra
        ];
      };
  };
}
