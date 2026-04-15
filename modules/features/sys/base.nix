{
  flake.aor.modules.feature.sys.base = {
    nixos =
      { pkgs, hostConfig, ... }:
      {
        networking.hostName = hostConfig.name;

        system.stateVersion = "25.11";

        environment = {
          systemPackages = with pkgs; [
            vim
            wget
            tree
            htop
            btop
            fd
            fzf
          ];

          variables.EDITOR = "nvim";
        };
      };
  };
}
