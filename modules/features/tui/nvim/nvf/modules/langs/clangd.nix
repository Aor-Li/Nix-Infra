{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      programs.nvf.settings.vim.languages.clang = {
        enable = true;
        cHeader = true;

        lsp.enable = true;
        treesitter.enable = true;

        
      };
    };
}
