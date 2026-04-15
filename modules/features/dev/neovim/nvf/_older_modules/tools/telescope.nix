let
  name = "feature/tui/nvim/nvf";
in {
  flake.modules.nvf.settings.vim = {
    programs.nvf.settings.vim = {
      telescope.enable = true;
    };
  };
}
