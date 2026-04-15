{...}: let
  name = "feature/tui/nvim/nvf";
in {
  flake.modules.homeManager.${name} = {...}: {
    programs.nvf.settings.vim = {
      # basic options
      options.tabstop = 2;
      options.shiftwidth = 2;
      options.shiftround = true;
      options.autoindent = true;

      options.wrap = false;
      options.mouse = "a";
      options.list = true;
      options.ignorecase = true;

      # leader key
      globals.mapleader = " ";
      globals.maplocalleader = "\\";

      # clip board
      clipboard.enable = true;
      clipboard.providers.xsel.enable = true;
      # clipboard.providers.wl-copy.enable = true;
    };
  };
}
