{ ... }:
let
  name = "feature/sys/fcitx5";
in
{
  flake.modules.homeManager.${name} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-gtk
            fcitx5-rime
            qt6Packages.fcitx5-configtool
            qt6Packages.fcitx5-chinese-addons
          ];
        };
      };

      systemd.user.sessionVariables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";

        SDL_IM_MODULE = "fcitx";
        GLFW_IM_MODULE = "ibus";
      };

      # 确保 home-manager 切配置时会自动拉起/重启 user services
      systemd.user.startServices = "sd-switch";

      # 在wsl环境下，利用systemd启动fcitx5
      systemd.user.services.fcitx5-deamon = {
        Unit = {
          Description = "Fcitx5 input method daemon (WSL)";
          After = [ "graphical-session-pre.target" ];
        };
        Service = {
          # 关键：用 fcitx5-with-addons，而不是裸的 ${pkgs.fcitx5}
          ExecStart = "${config.i18n.inputMethod.fcitx5.fcitx5-with-addons}/bin/fcitx5 -d";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      # set up config file
      #xdg.configFile."fcitx5/profile" = {
      #  source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      #  force = true;
      #};

      # set up env
      #home.sessionVariables = {
      #  GTK_IM_MODULE = "fcitx";
      #  QT_IM_MODULE = "fcitx";
      #  XMODIFIERS = "@im=fcitx";
      #};

      #services.fcitx5 = {
      #  enable = true;
      #  waylandFrontend = true;
      #};
      #programs.bash.initExtra = ''
      #  # start fcitx5 in bash if it is not started yet
      #  if ! pgrep -af "fcitx5" | grep -v grep > /dev/null; then
      #    nohup fcitx5 -d --replace > /dev/null 2>&1 &
      #  fi
      #'';
    };
}
