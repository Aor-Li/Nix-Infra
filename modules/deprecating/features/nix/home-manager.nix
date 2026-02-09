{ inputs, ... }:
let
  name = "feature/nix/home-manager";
in
{
  flake.modules = {
    nixos.${name} =
      { ... }:
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    homeManager.${name} =
      { userConfig, ... }:
      {
        programs.home-manager.enable = true;
        home.username = userConfig.username;
        home.homeDirectory = "/home/${userConfig.username}";
        home.stateVersion = "25.05";
      };
  };
}
