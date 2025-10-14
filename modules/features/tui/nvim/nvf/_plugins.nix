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

    # whichkey
    binds.whichKey = {
      enable = true;
      setupOpts.notify = true;
      setupOpts.preset = "modern"; # classic, modern, helix
      setupOpts.win.border = "rounded";
    };
  };
}
