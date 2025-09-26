{ ... }:
let
  name = "feature/system/xdg";
in
{
  flake.modules.homeManager.${name} =
    { config, pkgs, ... }:
    {
      # xdg packages
      home.packages = with pkgs; [
        xdg-utils # this tool controls xdg-mime applications (default apps for file types)
        xdg-user-dirs # this tool controls dirs like Downloads, Documents, ... in my $HOME
      ];

      # basic configs
      xdg = {
        enable = true;

        # config xdg dirs
        cacheHome = "${config.home.homeDirectory}/.cache";
        configHome = "${config.home.homeDirectory}/.config";
        dataHome = "${config.home.homeDirectory}/.local/share";
        stateHome = "${config.home.homeDirectory}/.local/state";
      };

      # todo: config xdg-mime applications here
    };
}
