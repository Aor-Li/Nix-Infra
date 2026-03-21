{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim = {

      utility.yazi-nvim = {
        enable = true;
        mappings = {
          openYazi = null;
          openYaziDir = null;
          yaziToggle = null;
        };
      };

      maps.normal = {
        "<leader>uy" = {
          desc = "Yazi";
          action = "<cmd>Yazi<cr>";
        };

        "<leader>uY" = {
          desc = "Yazi (Working Dir)";
          action = "<cmd>Yazi cwd<cr>";
        };

      };
    };
  };
}
