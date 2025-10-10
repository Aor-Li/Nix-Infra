{ inputs, ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      imports = [ inputs.nvf.homeManagerModules.default ];

      programs.nvf = {
        enable = false;
        settings = {
          vim.viAlias = false;
          vim.vimAlias = true;
          vim.lsp.enable = true;
        };
      };

    };
}
