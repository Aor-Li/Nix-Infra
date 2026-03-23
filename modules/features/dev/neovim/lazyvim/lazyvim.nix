{ config, ... }:
let
  inherit (config.flake.aor.meta) root;
in
{
  flake.aor.modules.feature.dev.neovim.lazyvim = {
    home =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.aor.modules.feature.dev.neovim.lazyvim;
      in
      {
        options.aor.modules.feature.dev.neovim.lazyvim = {
          enable = lib.mkEnableOption "";
        };

        config = lib.mkIf cfg.enable {

          xdg.configFile."lazyvim".source =
            config.lib.file.mkOutOfStoreSymlink "${root}/modules/features/dev/neovim/lazyvim/_lazyvim";

          home.packages = [
            (pkgs.writeShellScriptBin "nvim-lazy" ''
              export NVIM_APPNAME=lazyvim
              exec ${config.programs.neovim.finalPackage}/bin/nvim "$@"
            '')

            # lint
            pkgs.markdownlint-cli2
          ];

          home.shellAliases = {
            vi = "nvim-lazy";
            vim = "nvim-lazy";
            nvim = "nvim-lazy";
          };

        };
      };
  };
}
