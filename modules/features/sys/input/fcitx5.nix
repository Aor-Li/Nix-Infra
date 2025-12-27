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

      programs.bash.initExtra = ''
        # start fcitx5 in bash if it is not started yet
        if ! pgrep -af "fcitx5" | grep -v grep > /dev/null; then
          nohup fcitx5 --disable=wayland -d --replace > /dev/null 2>&1 &
        fi
      '';
    };
}
