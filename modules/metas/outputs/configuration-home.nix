{
  config,
  inputs,
  lib,
  ...
}:
let
  mkHomeManagerConfig =
    {
      username,
      hostname,
      module,
    }:
    let
      userConfig = config.flake.aor.meta.users.${username};
      hostConfig = config.flake.aor.meta.hosts.${hostname};
    in
    {
      name = "${username}@${hostname}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${hostConfig.system};
        modules = [
          module
        ];
        extraSpecialArgs = {
          inherit
            inputs
            userConfig
            hostConfig
            ;
        };
      };
    };
in
{
  # [TODO] 这里每个user记录其host，可能需要反过来记录机器上的用户
  flake.homeConfigurations =
    config.flake.aor.modules.home.user or { }
    |> lib.mapAttrsToList (
      username: module:
      let
        hostnames = config.flake.aor.meta.users.${username}.hosts;
      in
      map (hostname: mkHomeManagerConfig { inherit username hostname module; }) hostnames
    )
    |> lib.flatten
    |> lib.listToAttrs;
}
