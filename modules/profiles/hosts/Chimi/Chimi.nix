{ config, ... }:
let
  flake = {
    modules.nixos."host/Chimi" = {
      imports = [
        config.flake.modules.nixos."machine/server"
        ./_specifics/hardware-configuration.nix
      ];
      nixpkgs.hostPlatform.system = "x86_64-linux";
    };

    meta.hosts.Chimi = {
      name = "Chimi";
      description = "Chimi is a nixos server running in a mini-pc at home.";
      type = "server";
      system = "x86_64-linux";
      owner = {
        name = "Aor-Li";
        username = "aor";
        email = "liyifeng0039@gmail.com";
      };
    };
  };
in
{
  inherit flake;
}
