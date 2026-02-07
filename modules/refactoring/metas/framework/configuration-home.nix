{ config, inputs, lib, ... }:
let
  prefix = "user/";

  mkHomeManagerConfig =
    { username, hostname, module }:
    let
      userConfig = config.flake.meta.users.${username};
      hostConfig = config.flake.meta.hosts.${hostname};
      moduleConfig = config.flake.meta.modules;
      system = hostConfig.system;
    in
    {
      name = "${username}@${hostname}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          module
        ];
        extraSpecialArgs = {
          inherit inputs userConfig hostConfig moduleConfig;
        };
      };
    };
in
{
  flake.homeConfigurations =
    config.flake.modules.homeManager or { }
    |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
    |> lib.mapAttrsToList (
      name: module:
      let
        username = lib.removePrefix prefix name;
        hostnames = config.flake.meta.users.${username}.hosts;
      in
        map (hostname: mkHomeManagerConfig { inherit username hostname module; }) hostnames
    )
    |> lib.flatten
    |> lib.listToAttrs;
}
