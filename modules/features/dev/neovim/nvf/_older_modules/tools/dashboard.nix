{inputs, ...}: let
  name = "feature/tui/nvim/nvf";
in {
  flake.modules.homeManager.${name} = {...}: {
    programs.nvf.settings.vim.utility.snacks-nvim.setupOpts.dashboard = {
      enable = false;
    };
  };
}
