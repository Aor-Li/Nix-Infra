{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings.vim.debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };
    };
}
