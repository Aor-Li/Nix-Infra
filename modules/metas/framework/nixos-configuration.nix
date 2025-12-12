/*
  Create NixOS configurations:
    - modules: flake.modules.nixos.${machine}, which is defined in modules/profiles/machines/${machine}
    - setting: flake.meta.machine.${machine}, which will be passed to all NixOS modules as hostConfig
*/
{
  config,
  inputs,
  lib,
  ...
}:
let
  prefix = "host/";
in
{
  flake.nixosConfigurations =
    config.flake.modules.nixos or { }
    |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
    |> lib.mapAttrs' (
      name: module:
      let
        host = lib.removePrefix prefix name;
      in
      {
        name = host;
        value = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            module
            {
              options.infra = lib.mkOption {
                type = lib.types.submodule { };
                default = { };
                description = "Infrastructure configuration options for nixos.";
              };
            }
          ];
          specialArgs = {
            hostConfig = config.flake.meta.hosts.${host} or { };
          };
        };
      }
    );
}
