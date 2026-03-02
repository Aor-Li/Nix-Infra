{
  flake.aor.modules.feature.nix.nix-index = {
    nixos = {
      programs.nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
