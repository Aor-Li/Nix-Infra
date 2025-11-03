{ ... }:
let
  name = "feature/sys/fcitx5";
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
          fcitx5-gtk
          fcitx5-rime
          qt6Packages.fcitx5-configtool
          qt6Packages.fcitx5-chinese-addons
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
        if ! pgrep -af "fcitx5" | grep -v grep > /dev/null; then
          nohup fcitx5 -d --replace > /dev/null 2>&1 &
        fi
      '';
    };
}
