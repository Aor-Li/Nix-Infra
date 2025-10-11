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
        ./_appearance.nix
        ./_binds.nix
        # ./_languages.nix

        ./_snacks-nvim.nix
      ];
      programs.nvf.enable = false;
    };
}
