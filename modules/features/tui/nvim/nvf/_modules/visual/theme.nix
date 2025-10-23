{...}: let
  name = "feature/tui/nvim/nvf";
in {
  flake.modules.homeManager.${name} = {...}: {
    programs.nvf.settings.vim.theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };
  };
}
