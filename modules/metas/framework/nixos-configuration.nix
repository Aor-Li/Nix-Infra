{
  config,
  inputs,
  lib,
  ...
}:
let
  prefix = "host/";

  mkNixosConfig =
    { hostname, module }:
    let
      hostConfig = config.flake.meta.hosts.${hostname};
      moduleConfig = config.flake.meta.modules;
    in
    {
      name = hostname;
      value = inputs.nixpkgs.lib.nixosSystem {
        modules = [ module ];
        specialArgs = {
          inherit hostConfig moduleConfig;
        };
      };
    };
in
{
  flake.nixosConfigurations =
    config.flake.modules.nixos or { }
    |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
    |> lib.mapAttrs' (
      name: module:
      let
        hostname = lib.removePrefix prefix name;
      in
      mkNixosConfig { inherit hostname module; }
    );
}
