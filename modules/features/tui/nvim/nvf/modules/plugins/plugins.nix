{ inputs, ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.nvf.settings.vim = {

        # snacks-nvim: see https://github.com/folke/snacks.nvim
        utility.snacks-nvim = {
          enable = true;
          setupOpts = {
            bigfile.enable = true;
            picker.enable = true;
            explorer.enable = true;
          };
        };

        # mini-nvim: see https://github.com/nvim-mini/mini.nvim
        mini = {
          icons.enable = true;
        };

        # whichkey
        binds.whichKey = {
          enable = true;
          setupOpts.notify = true;
          setupOpts.preset = "helix"; # classic, modern, helix
          setupOpts.win.border = "rounded";
        };

        # telescope
        telescope.enable = true;

        # web icons
        visuals.nvim-web-devicons.enable = true;
      };
    };
}
