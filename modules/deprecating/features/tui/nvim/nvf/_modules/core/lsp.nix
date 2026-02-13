{ ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings.vim.lsp = {
        enable = true;
        formatOnSave = true;

        # plugins
        lspkind.enable = true;
        lightbulb.enable = true;
        # TODO maybe try those plugins later
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = false;
        otter-nvim.enable = false;
        nvim-docs-view.enable = false;
      };
    };
}
