{
  flake.aor.modules.feature.dev.neovim = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          neovim
        ];
      };

    home =
      { config, lib, ... }:
      let
        cfg = config.aor.modules.feature.dev.neovim;
      in
      {
        options.aor.modules.feature.dev.neovim = {
          impl = lib.mkOption {
            type = lib.types.enum [
              "nvf"
              "nixcat"
              "lazyvim"
            ];
            default = "lazyvim";
            description = "Neovim implementation to use";
          };
        };

        config = {
          programs.neovim = {
            enable = true;
          };
          aor.modules.feature.dev.neovim = lib.mkMerge [
            (lib.mkIf (cfg.impl == "nvf") {
              nvf.enable = true;
            })
            (lib.mkIf (cfg.impl == "nixcat") {
              nixcat.enable = true;
            })
            (lib.mkIf (cfg.impl == "lazyvim") {
              lazyvim.enable = true;
            })
          ];
        };
      };
  };
}
