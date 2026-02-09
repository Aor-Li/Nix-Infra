{
  config,
  inputs,
  lib,
  ...
}:
let
  mkNixosConfig =
    {
      hostname,
      module,
    }:
    let
      hostConfig = config.flake.meta.hosts.${hostname};
      moduleConfig = config.flake.meta.modules; # [TODO] 修改名字为partConfig,位置移动到flake.modules.parts下
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
    config.flake.aor.modules.nixos.host or { }
    |> lib.mapAttrs' (hostname: module: mkNixosConfig { inherit hostname module; });
}
