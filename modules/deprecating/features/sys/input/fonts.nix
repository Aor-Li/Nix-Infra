{ ... }:
let
  name = "feature/sys/fonts";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        # notos
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        # nerd-fonts
        nerd-fonts.monaspace
        nerd-fonts.caskaydia-cove
        maple-mono.NF-CN

        # 1. Combination: JetBrainsMono + Sarasa
        nerd-fonts.jetbrains-mono
        sarasa-gothic
        
        # 2. Combination: ComicSansMono + LXGW WenKai
        nerd-fonts.comic-shanns-mono
        lxgw-fusionkai
      ];
    };
}
