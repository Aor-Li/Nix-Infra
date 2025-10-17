{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings.vim = {

        # icons
        mini.icons.enable = true;
        visuals.nvim-web-devicons.enable = true;

        # status line
        statusline.lualine = {
          enable = true;
          theme = "catppuccin";
        };

        # tab line
        tabline.nvimBufferline.enable = true;
      };
    };
}
