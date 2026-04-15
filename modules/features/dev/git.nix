{
  flake.aor.modules.feature.dev.git = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          git
        ];
      };

    home =
      { userConfig, ... }:
      {
        programs.git = {
          enable = true;
          settings = {
            user.email = userConfig.email;
            user.name = userConfig.fullname;
            # http.sslVerify = false;
            # https.sslVerify = false;
          };
        };
        programs.lazygit.enable = true;
      };
  };
}
