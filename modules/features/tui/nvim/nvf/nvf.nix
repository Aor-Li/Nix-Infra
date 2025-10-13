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

        ./default/_options.nix
        # ./default/_keymaps.nix

        ./plugins/_appearance.nix
        ./plugins/_whichkey.nix
        ./plugins/_snacks.nix

        ./langs/_languages.nix

      ];
      programs.nvf.enable = true;
    };
}
