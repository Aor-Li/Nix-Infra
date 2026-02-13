{ ... }:
let
  name = "feature/sys/user";
in
{
  flake.modules.nixos.${name} =
    { hostConfig, ... }:
    {
      users.users.${hostConfig.owner.username} = {
        isNormalUser = true;
        initialPassword = "";
        extraGroups = [
          "wheel"
          # todo: extra groups should be set in required feature module
          "networkmanager"
        ];
      };
      # todo: add settings for other users
    };
}
