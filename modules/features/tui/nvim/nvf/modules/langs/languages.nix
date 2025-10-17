{...}: let
  name = "feature/tui/nvim/nvf";
in {
  flake.modules.homeManager.${name} = {...}: {
    programs.nvf.settings.vim.languages = {
      # settings
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # langs
      nix.enable = true;
      clang.enable = true;
      markdown.enable = true;
    };
  };
}
