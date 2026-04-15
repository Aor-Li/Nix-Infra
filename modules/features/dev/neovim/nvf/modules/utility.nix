{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim.utility = {
      # functions
      diffview-nvim.enable = true;
      motion.flash-nvim.enable = true;
      sleuth.enable = true;
      multicursors.enable = true;

      yanky-nvim = {
        enable = true;
        # default setting "shada" seems broken
        setupOpts.ring.storage = "sqlite";
      };

      # snack-nvim boundle
      snacks-nvim = {
        enable = true;
        setupOpts = {

          explorer.enable = false;

          # [NOTE] dashboard 看起来有很多依赖，后续再安装
          #dashboard.enable = false;
        };
      };

      # nix envs
      direnv.enable = true;
      nix-develop.enable = true;
    };
  };
}
