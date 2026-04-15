{
  flake.aor.modules.feature.dev.langs.python = {
    home =
      { pkgs, ... }:
      let
        python = pkgs.python3;
      in
      {
        home.packages = [
          python
        ];
      };
  };
}
