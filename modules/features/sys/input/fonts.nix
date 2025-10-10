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
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        # nerd-fonts
        nerd-fonts.monaspace
        nerd-fonts.caskaydia-cove
      ];
    };
}
