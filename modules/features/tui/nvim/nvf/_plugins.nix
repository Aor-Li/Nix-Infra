{

  programs.nvf.settings.vim = {

    # snacks-nvim: see https://github.com/folke/snacks.nvim
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        bigfile.enable = true;
        dashboard.enable = false;
        picker.enable = true;
        explorer.enable = true;
      };
    };

    # mini-nvim: see https://github.com/nvim-mini/mini.nvim
    mini = {
      icons.enable = true;
    };

    # whichkey
    binds.whichKey = {
      enable = true;
      setupOpts.notify = true;
      setupOpts.preset = "helix"; # classic, modern, helix
      setupOpts.win.border = "rounded";
    };

    # web icons
    visuals.nvim-web-devicons.enable = true;
  };
}
