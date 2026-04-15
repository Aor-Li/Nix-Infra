{
  flake.aor.modules.feature.dev.yazi = {

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          (yazi.override {
            _7zz = _7zz-rar; # Support for RAR extraction
          })
        ];
      };

    home =
      { ... }:
      {
        # config y command in bash/fish
        programs.bash.initExtra = builtins.readFile ./scripts/y.sh;
        xdg.configFile."fish/functions/y.fish".text = builtins.readFile ./scripts/y.fish;
      };

  };
}
