{
  flake.aor.modules.feature.sys.user = {
    nixos =
      { hostConfig, ... }:
      {
        users.users.${hostConfig.owner.username} = {
          isNormalUser = true;
          initialPassword = "";

          # [TODO]: extra groups should be set in required feature module
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };
      };
    # [TODO]: add settings for all users defined in hostConfig.users
  };
}
