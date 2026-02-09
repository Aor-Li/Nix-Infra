{ config, inputs, ... }:
let
  inherit (config.flake) aor;

  nixos =
    { config, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  home =
    { userConfig, ... }:
    {
      programs.home-manager.enable = true;
      home.username = userConfig.username;
      home.homeDirectory = "/home/${userConfig.username}";
      home.stateVersion = "25.05";
    };
in
{
  flake.aor.modules.feature.nix.home-manager = {
    inherit nixos home;
  };
}
