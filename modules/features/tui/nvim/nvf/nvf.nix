{ inputs, ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      imports = [
        inputs.nvf.homeManagerModules.default
        ./_options.nix
        ./_appearance.nix
        ./_languages.nix
        ./_plugins.nix
      ];
      programs.nvf.enable = true;
    };
}
