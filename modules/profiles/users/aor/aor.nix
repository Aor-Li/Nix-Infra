{ config, ... }:
let
  inherit (config.flake) aor;

  flake.aor = {

    # --- user info ---
    meta.users.aor = {
      username = "aor";
      fullname = "Aor-Li";
      email = "liyifeng0039@gmail.com";
      hosts = [
        "Amanojaku"
        "Bakotsu"
        "Chimi"
      ];
    };

    # --- add user role modules ---
    modules.home.user.aor =
      { config, userConfig, ... }:
      {
        # add roles
        imports = with aor.modules.home.role; [
          common
          coder
          gamer
        ];

        sops.defaultSopsFile = ./secrets/secrets.yaml;

        # [TODO] 具体的secret考虑要不要移动到具体功能处处理
        sops.secrets.github_access_token.path = "/home/${userConfig.username}/.secrets/github_access_token";

        # [TODO] secrets/.sops.yaml需要理解下规则并重写
      };
  };
in
{
  inherit flake;
}
