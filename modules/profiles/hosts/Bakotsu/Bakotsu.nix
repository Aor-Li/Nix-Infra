{ config, ... }:
let
  flake.aor = {

    # --- host info ---
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

    # --- add host machine modules ---
    modules.nixos.host.Bakotsu = {
      imports = [
        ./_specifics/specifics.nix
        config.flake.aor.modules.nixos.machine.wsl
      ];
      nixpkgs.hostPlatform.system = "x86_64-linux"; # [TODO] 测试这个配置是否必要
    };
  };
in
{
  inherit flake;
}
