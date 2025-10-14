{
  programs.nvf.settings = {
    vim.languages = {
      enableLSP = true;
      enableTreesitter = true;
    };


    # nix
    vim.languages.nix.enable = true;
  };
}
