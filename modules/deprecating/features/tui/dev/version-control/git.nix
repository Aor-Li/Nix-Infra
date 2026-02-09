{ ... }:
let
  name = "feature/tui/dev/git";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, userConfig, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user.email = userConfig.email;
          user.name = userConfig.fullname;
          http.sslVerify = false;
          https.sslVerify = false;
        };
      };

      programs.lazygit.enable = true;
    };
}
