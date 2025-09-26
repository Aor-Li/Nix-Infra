{ ... }:
let
  name = "feature/tui/shell/alias";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    let
      aliases = {
        ns = "sudo nixos-rebuild switch --flake ~/configs/infra";
        hs = "sudo home-manager switch --flake ~/configs/infra";
      };
    in
    {
      programs.bash.shellAliases = aliases;
      programs.fish.shellAliases = aliases;
    };
}
