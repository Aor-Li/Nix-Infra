{
  flake.aor.modules.feature.nix.settings = {
    nixos =
      { config, ... }:
      {
        nix.settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];

          trusted-users = [ "@wheel" ];

          substituters = [
            "https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          ];

          trusted-public-keys = [
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
          ];

        };

        # [TODO]: 修改为使用nix-index
        programs.command-not-found.enable = false;

        # [TODO]: 之后在overlay目录下配置nixpkgs
        nixpkgs.config.allowUnfree = true;
      };

    home = {
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
  };
}
