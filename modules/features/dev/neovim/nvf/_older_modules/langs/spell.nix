{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings.vim.spellcheck = {
        enable = false;
        programmingWordlist.enable = false; # alias of vim-dirtytalk
      };
    };
}
