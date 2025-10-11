{ ... }:
let
  name = "feature/gui/magick";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imagemagick
      ];
    };
}
