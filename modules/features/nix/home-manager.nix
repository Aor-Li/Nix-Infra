{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.aor.modules.feature.nix.home-manager = {
    home =
      { userConfig, ... }:
      {
        programs.home-manager.enable = true;
        home.username = userConfig.username;
        home.homeDirectory = "/home/${userConfig.username}";
        home.stateVersion = "25.05";
      };
  };
}
