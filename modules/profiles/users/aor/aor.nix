{ config, ... }:
let
  flake = {
    modules.homeManager."user/aor" = {
      imports = [
        config.flake.modules.homeManager."role/common"
        config.flake.modules.homeManager."role/coder"
        config.flake.modules.homeManager."role/gamer"
      ];
    };

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
  };
in
{
  inherit flake;
}
