{
  flake.aor.modules.feature.dev.direnv = {
    home = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
