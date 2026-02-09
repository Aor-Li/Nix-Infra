{ inputs, ... }:
let
  name = "feature/desktop/niri";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, lib, hostConfig, ... }:
    {
      imports = [ inputs.niri.homeModules.niri ];
      
      programs.niri.enable = true;
      
      /* 

      # Add niri overlay to get niri-unstable
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];

      programs.niri = {
        enable = true;
        # Use niri-unstable for include syntax support (required by DMS)
        package = pkgs.niri-unstable;
      }; */
    };
}
