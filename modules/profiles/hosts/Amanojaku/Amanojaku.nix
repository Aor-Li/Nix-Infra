{ config, ... }:
let
  inherit (config.flake) aor;

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
    modules.profile.host.Amanojaku = {
      imports = [
        aor.modules.prototype.machine.wsl
      ];
      nixpkgs.hostPlatform.system = "x86_64-linux"; # [TODO] 测试这个配置是否必要
    };
  };
in
{
  inherit flake;
}
