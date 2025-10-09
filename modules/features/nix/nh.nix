{ ... }:
let
  name = "feature/nix/nh";
in
{
  flake.modules = {
    nixos.${name} = {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/aor/configs/infra";
      };
    };
  };
}
