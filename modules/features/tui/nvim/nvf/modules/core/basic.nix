# This module most basic neovim settings
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} = {
    programs.nvf.settings.vim = {
      options = {
        # indentation
        tabstop = 2;
        shiftwidth = 2;
        shiftround = true;
        autoindent = true;
        expandtab = true;
        smartindent = true;
        breakindent = true;

        # line and basic sign
        number = true;
        relativenumber = true;
        signcolumn = "yes";
        termguicolors = true;

        # search
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        incsearch = true;

        # interactive
        updatetime = 200;
        timeoutlen = 300;
        scrolloff = 4;
        sidescrolloff = 8;
        splitright = true;
        splitbelow = true;
        splitkeep = "screen";
        undofile = true;
        swapfile = false;
        backup = false;

        # symbols
        list = true;
        listchars = "tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣";

        # extras
        confirm = true;
        pumheight = 10;
        completeopt = "menu,menuone,noselect";
        foldenable = false;
        grepprg = "rg --vimgrep --no-heading --smart-case"; # if ripgrep available

        # others
        mouse = "a";
        wrap = false;
        showmode = false;
        encoding = "utf-8";
      };

      globals.mapleader = " ";
      globals.maplocalleader = "\\";

      clipboard.enable = true;
      clipboard.providers.xsel.enable = true;
      # Wayland 主机覆盖开启：
      # clipboard.providers.wl-copy.enable = true;
    };
  };
}
