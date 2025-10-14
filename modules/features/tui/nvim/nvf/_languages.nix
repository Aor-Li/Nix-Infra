{
  programs.nvf.settings = {
    vim.languages = {
      enableFormat = true;
      enableTreesitter = true;
    };

    # nix
    vim.languages.nix.enable = true;
  };
}
