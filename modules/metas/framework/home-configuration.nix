/*
  Create home-manager configurations：
    - modules：flake.modules.homeManager.${user}, which is defined in modules/profiles/users/${user}
    - setting: flake.meta.user.${user}, which will be passed to all homeManager modules as userConfig
*/
{
  config,
  inputs,
  lib,
  ...
}:
let
  prefix = "user/";

  mkHomeManagerConfig =
    { username, hostname, module, }:
    let
      userConfig = config.flake.meta.users.${username};
      hostConfig = config.flake.meta.hosts.${hostname};
      flakeConfig = config.flake.moduleOptions;
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
          inherit inputs userConfig hostConfig flakeConfig ;
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
