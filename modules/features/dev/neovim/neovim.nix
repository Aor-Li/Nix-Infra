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
            default = "nvf";
            description = "Neovim implementation to use";
          };
        };

        config = {
          programs.neovim = {
            enable = true;
          };
          aor.modules.feature.dev.neovim = lib.mkMerge [
            (lib.mkIf (cfg.impl == "nvf") {
              cfg.nvf.enable = true;
            }),
            (lib.mkIf (cfg.impl == "nvf") {
              cfg.nvf.enable = true;
            }),
            (lib.mkIf (cfg.impl == "nvf") {
              cfg.nvf.enable = true;
            }),
          ];
        };
      };
  };
}
