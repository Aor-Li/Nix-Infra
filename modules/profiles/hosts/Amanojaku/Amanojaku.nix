{ config, ... }:
let
  flake.aor = {

    # --- host info ---
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

    # --- add host machine modules ---
    modules.nixos.host.Amanojaku = {
      imports = [
        config.flake.aor.modules.nixos.machine.wsl
      ];
      nixpkgs.hostPlatform.system = "x86_64-linux"; # [TODO] 测试这个配置是否必要
    };
  };
in
{
  inherit flake;
}
