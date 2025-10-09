{ ... }:
let
  name = "feature/nix/settings";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
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
          #"https://cuda-maintainers.cachix.org"
        ];

        trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };

      # nixpkgs.config.allowUnfree = true;
    };
}
