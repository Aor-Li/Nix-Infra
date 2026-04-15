{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings.vim = {
        autopairs.nvim-autopairs.enable = true;
      };
    };
}
