{ ... }:
let
  name = "feature/sys/basic/tools";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        git
        wget
        tree

        htop
        btop

        fd
        fzf
      ];
    };
}
