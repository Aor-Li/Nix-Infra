{
  programs.nvf.settings = {
    vim.languages = {
      enableLSP = true;
      enableTreesitter = true;
      enableFormat = true;
    };

    # nix
    vim.languages.nix.enable = true;
  };
}
