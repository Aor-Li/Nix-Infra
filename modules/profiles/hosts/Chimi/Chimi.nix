{ config, ... }:
let
  inherit (config.flake) aor;

  flake.aor = {

    # --- host info ---
    meta.hosts.Chimi = {
      description = "Chimi is a nixos server running in a mini-pc at home.";
      name = "Chimi";
      type = "server";
      distro = "nixos";
      system = "x86_64-linux";
      owner = {
        name = "Aor-Li";
        username = "aor";
        email = "liyifeng0039@gmail.com";
      };
    };

    # --- add host machine modules ---
    modules.profile.host.Chimi = {
      imports = [
        aor.modules.prototype.machine.server
        ./_specifics/hardware-configuration.nix
      ];
      nixpkgs.hostPlatform.system = "x86_64-linux"; # [TODO] 测试这个配置是否必要
    };

  };
in
{
  inherit flake;
}
