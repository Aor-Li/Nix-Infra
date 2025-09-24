{ ... }:
let
  name = "feature/basic/fcitx5";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          fcitx5-rime
          fcitx5-configtool
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };

      xdg.configFile."fcitx5/profile" = {
        source = ./profile;
        # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
        # so we need to force replace it in every rebuild to avoid file conflict.
        force = true;
      };
    };
}
