{ inputs, ... }:
let
  name = "feature/nix/secret";
in
{
  # [TODO] 考虑在nixos层按照sops，并且分别提供host和user层的secrets配置

  flake.modules.homeManager.${name} =
    {
      config,
      lib,
      pkgs,
      userConfig,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      home.packages = [
        pkgs.age
        pkgs.sops
      ];

      sops.age.keyFile = lib.mkDefault "/home/${userConfig.username}/.config/sops/age/keys.txt";
    };
}
