{ inputs, ... }:
{
  flake.aor.modules.feature.desktop.session.niri = {
    nixos = {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri.enable = true;
    };
    home = { };
  };
}
