{ inputs, ... }:
{
  flake.aor.modules.feature.desktop.session.niri = {
    nixos = {
      programs.niri.enable = true;
    };
    home = {
      imports = [ inputs.niri.homeModules.niri ];
    };
  };
}
