# This module most basic neovim settings
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} = {
    programs.nvf.settings.vim = {
      # basic options
      options.tabstop = 2;
      options.shiftwidth = 2;
      options.shiftround = true;
      options.autoindent = true;
      options.expandtab = true;
      options.smartindent = true;
      options.breakindent = true;

      # line and basic sign
      options.number = true;
      options.relativenumber = true;
      options.signcolumn = "yes";
      options.termguicolors = true;

      # search
      options.ignorecase = true;
      options.smartcase = true;
      options.hlsearch = true;
      options.incsearch = true;

      # interactive
      options.updatetime = 200;
      options.timeoutlen = 300;
      options.scrolloff = 4;
      options.sidescrolloff = 8;
      options.splitright = true;
      options.splitbelow = true;
      options.splitkeep = "screen";
      options.undofile = true;
      options.swapfile = false;
      options.backup = false;

      # symbols
      options.list = true; # Show some invisible characters
      options.listchars = "tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣";

      # something else
      options.mouse = "a";
      options.wrap = false;

      # leader key
      globals.mapleader = " ";
      globals.maplocalleader = ",";

      # clip board
      clipboard.enable = true;
      clipboard.providers.xsel.enable = true;
      # use wl-copy for wayland
      # clipboard.providers.wl-copy.enable = true;
    };
  };
}
