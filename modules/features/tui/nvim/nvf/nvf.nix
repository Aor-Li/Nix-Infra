{ inputs, ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} = {
    imports = [
      inputs.nvf.homeManagerModules.default
    ];

    programs.nvf = {
      enable = false;
      enableManpages = false;
    };
  };
}
