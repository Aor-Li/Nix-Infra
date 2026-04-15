{
  flake.aor.modules.feature.dev.neovim.nvf.home = {
    programs.nvf.settings.vim = {
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      statusline.lualine = {
        enable = true;
        theme = "catppuccin";
      };

      tabline.nvimBufferline = {
        enable = true;
      };

    };
  };
}
