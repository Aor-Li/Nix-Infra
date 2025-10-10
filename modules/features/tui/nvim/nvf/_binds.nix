{
  programs.nvf.settings.vim.binds = {
    whichkey = {
      enable = true;
      presets = {
        operators = true;
        setupOpts.notify = true;
        setupOpts.preset = "modern"; # classic, modern, helix
        setupOpts.win.border = "rounded";
      };
    };
  };
}
