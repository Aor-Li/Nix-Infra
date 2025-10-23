{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} = 
    { ... }:
    {
      programs.nvf.settings.vim.visuals = {
        nvim-scrollbar.enable = false;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;

        highlight-undo.enable = true;
        indent-blankline.enable = true;
 
        cellular-automaton.enable = false;
      };
    };
}
