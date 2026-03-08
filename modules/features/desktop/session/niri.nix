{
  flake.aor.modules.feature.desktop.session.niri = {
    nixos =
      { ... }:
      {
        programs.niri.enable = true;
      };
  };
}
