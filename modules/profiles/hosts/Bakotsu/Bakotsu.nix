{ config, ... }:
let
  flake = {
    modules.nixos."host/Bakotsu" = {
      imports = [
        ./_specifics/specifics.nix
        config.flake.modules.nixos."machine/wsl"
      ];
      nixpkgs.hostPlatform.system = "x86_64-linux";
    };
    meta.hosts.Bakotsu = {
      name = "Bakotsu";
      description = "Bakotsu is a wsl nixos system on my safe-pc at work.";
      type = "wsl";
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
