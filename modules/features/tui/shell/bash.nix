{ ... }:
let
  name = "feature/tui/shell/bash";
in
{
  flake.modules = {
    homeManager.${name} =
      { ... }:
      {
        programs.bash = {
          enable = true;
          initExtra = ''
            # call fish in interactive shell
            # fish
          '';
        };
      };
  };
}
