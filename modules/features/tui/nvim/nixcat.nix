{ inputs, ... }:
let
  name = "feature/tui/nvim/nixcat";
in
{
  flake.modules = {
    homeManager.${name} =
      { config, ... }:
      {
        imports = [ inputs.lazyvim.homeModules.default ];
        nvim.enable = true;
      };
  };
}
