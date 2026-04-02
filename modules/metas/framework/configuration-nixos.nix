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
      hostConfig = config.flake.aor.meta.hosts.${hostname};
    in
    {
      name = hostname;
      value = inputs.nixpkgs.lib.nixosSystem {
        modules = [ module ];
        specialArgs = {
          inherit hostConfig;
        };
      };
    };
in
{
  flake.nixosConfigurations =
    config.flake.aor.modules.profile.host or { }
    |> lib.filterAttrs (
      hostname: _: config.flake.aor.meta.hosts.${hostname}.distro == "nixos"
    )
    |> lib.mapAttrs' (hostname: module: mkNixosConfig { inherit hostname module; });
}
