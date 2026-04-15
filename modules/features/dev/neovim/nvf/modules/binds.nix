{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim.binds = {

      cheatsheet.enable = true;

      hardtime-nvim.enable = false;

      whichKey = {
        enable = true;
        setupOpts = {
          preset = "helix";
        };

        register = {
          "<leader>u" = "+ui";
        };

      };
    };
  };
}
