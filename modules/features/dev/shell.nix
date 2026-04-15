{
  flake.aor.modules.feature.dev.shell = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          bash
          fish
        ];
      };

    home = {
      programs.bash.enable = true;
      programs.fish.enable = true;
    };
  };
}
