{
  flake.aor.modules.feature.dev.git = {
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
