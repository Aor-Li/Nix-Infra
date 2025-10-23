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
        lsp.enable = true;

        # dap
        dap.enable = true;

        # others
        treesitter.enable = true;
        cHeader = true; # enable .h files support
      };
    };
}
