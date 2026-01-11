{ config, ... }:
let
  flake = {
    modules.nixos."host/Amanojaku" =
      { ... }:
      {
        imports = [
          config.flake.modules.nixos."machine/wsl"
        ];
        nixpkgs.hostPlatform.system = "x86_64-linux";
      };

    meta.hosts.Amanojaku = {
      name = "Amanojaku";
      description = "Amanojaku is a wsl nixos system on my win11 pc with nvdia gpu.";
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
