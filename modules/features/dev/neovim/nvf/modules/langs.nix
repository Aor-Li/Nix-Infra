{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim.languages = {

      enableTreesitter = true;

      clang = {
        enable = true;
        lsp.enable = true;
        dap.enable = true;
        treesitter.enable = true;
      };

      nix = {
        enable = true;
      };

      markdown = {
        enable = true;
      };

    };
  };
}
