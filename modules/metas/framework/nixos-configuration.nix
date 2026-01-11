{ config, inputs, lib, ... }:
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
        modules = [
          module
          # [FIXME]: 下面配置我已经忘了作用，不需要的话就删掉
          # {
          #   options.infra = lib.mkOption {
          #     type = lib.types.submodule { };
          #     default = { };
          #     description = "Infrastructure configuration options for nixos.";
          #   };
          # }
        ];
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
