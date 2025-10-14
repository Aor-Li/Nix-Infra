{
  programs.nvf.settings.vim = {
    # leader key
    globals.mapleader = " ";
    globals.maplocalleader = "\\";

    # formatting
    lsp.enable = true;
    lsp.formatOnSave = true;

    # clip board
    clipboard.enable = true;
    clipboard.providers.xsel.enable = true;
    clipboard.providers.wl-copy.enable = true;
  };
}
