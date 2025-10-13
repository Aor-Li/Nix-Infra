{
  programs.nvf.settings.vim.utility = {

    # snacks-nvim: see https://github.com/folke/snacks.nvim
    snacks-nvim = {
      enable = true;
      setupOpts = {
        bigfile.enable = true;
        dashboard.enable = true;

        picker.enable = true;
        explorer.enable = true;
      };
    };
  };
}
