{ inputs, ... }:
{
  flake.aor.modules.feature.nix.secret = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          age
          sops
        ];
        # [TODO]: 考虑在nixos层安装sops，并且提供host层的secrets配置
      };

    home = 
    { config, pkgs, lib, userConfig, ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      
      sops.age.keyFile = lib.mkDefault "/home/${userConfig.username}/.config/sops/age/keys.txt";
    };
  };
}
