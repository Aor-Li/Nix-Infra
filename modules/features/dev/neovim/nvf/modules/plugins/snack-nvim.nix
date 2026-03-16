{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim = {
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard.enable = false;
          explorer.enable = false;
        };
      };
    };
  };
}
