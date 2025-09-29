{ inputs, ... }:
let
  name = "feature/nix/secret";
in
{
  flake.modules.homeManager.${name} =
    {
      config,
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

      sops = {
        age.keyFile = "/home/${userConfig.username}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../../secrets/secrets.yaml;
      };

      #programs.bash.sessionVariables = {
      #  TEST_SECRET = config.sops.secrets.github_access_token;
      #};
    };
}
