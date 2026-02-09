{ ... }:
let
  name = "feature/nix/format";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
    {
      environment.systemPackages = [ 
        pkgs.nixfmt # pkgs.nixfmt-rfc-style
        pkgs.alejandra # much more condensed
      ]; 
    };
}
