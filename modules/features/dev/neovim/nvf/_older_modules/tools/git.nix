let
  name = "feature/tui/nvim/nvf";
in {
  flake.module.homeManager.${name} = {
    programs.nvf.settings.vim = {
      git.enable = true;
      gitsigns = {
        enable = true;
        codeActions.enable = true;
        neogit.enable = true;
      };
    };
  };
}
