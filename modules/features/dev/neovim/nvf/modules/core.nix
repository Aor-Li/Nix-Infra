{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim = {
      options = {
        # tab and indents
        tabstop = 2;
        shiftwidth = 2;
        shiftround = true;
        autoindent = true;

        mouse = "a";
        wrap = false;
        cursorlineopt = "both";
      };

      globals = {
        mapleader = " ";
        maplocalleader = "\\";
      };

      clipboard = {
        enable = true;
        providers.xsel.enable = true;
        providers.wl-copy.enable = true;
      };

      searchCase = "smart";

      telescope.enable = true;
    };
  };
}
