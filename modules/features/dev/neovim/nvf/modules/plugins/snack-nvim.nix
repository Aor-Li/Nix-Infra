{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim = {
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {

          explorer.enable = false;

          # [NOTE] dashboard 看起来有很多依赖，后续再安装
          #dashboard.enable = false;
        };
      };
    };
  };
}
