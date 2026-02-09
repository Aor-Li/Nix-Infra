{ ... }:
let
  name = "feature/tui/dev/github-cli";
in
{
  flake.modules.homeManager.${name} =
    { inputs, ... }:
    {
      programs.gh.enable = true;
    };
}
