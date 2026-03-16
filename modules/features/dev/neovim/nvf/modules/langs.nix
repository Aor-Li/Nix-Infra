{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.vim.languages = {
      enableTreesitter = true;

      clang = {
        enable = true;
        lsp.enable = true;
        dap.enable = true;
        treesitter.enable = true;
      };

    };
  };
}
