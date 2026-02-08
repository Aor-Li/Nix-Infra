{ config, ... }:
let
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
    modules.homeManager.user.aor = {
      imports = [
        config.flake.modules.homeManager."role/common" # fixme
        config.flake.modules.homeManager."role/coder" # fixme
        config.flake.modules.homeManager."role/gamer" # fixme
      ];
    };

  };
in
{
  inherit flake;
}
