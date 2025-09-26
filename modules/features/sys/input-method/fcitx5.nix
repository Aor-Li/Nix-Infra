{ ... }:
let
  name = "feature/system/input-method";
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

      # set up config file
      xdg.configFile."fcitx5/profile" = {
        source = ./profile;
        # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
        # so we need to force replace it in every rebuild to avoid file conflict.
        force = true;
      };

      # set up env
      home.sessionVariables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
      };

      programs.bash.initExtra = ''
        # start fcitx5 in bash if it is not started yet
        if ! pgrep -x "fcitx5" > /dev/null; then
        fcitx5 -d --replace > /dev/null 2>&1 &
        fi
      '';
    };
}
