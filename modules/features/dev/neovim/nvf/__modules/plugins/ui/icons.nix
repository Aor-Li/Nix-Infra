let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} = {
    programs.nvf.settings.vim = {
      mini.icons.enable = true;
      visuals.nvim-web-devicons.enable = true;
    };
  };
}
