{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings = {
        vim.languages = {
          enableFormat = true;
          enableTreesitter = true;
        };

        vim.languages.clang.enable = true;
        vim.languages.nix.enable = true;
      };
    };
}
