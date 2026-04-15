{
  flake.aor.modules.feature.sys.shell = {
    home = {
      # 确保一些TUI程序色彩显示正常
      home.sessionVariables.COLORTERM = "truecolor";
      systemd.user.sessionVariables.COLORTERM = "truecolor";
    };
  };
}
