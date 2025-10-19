let
  name = "feature/tui/nvim/nvf";
in {
  flake.modules.homeManager.${name} = {
    programs.nvf.settings.vim = {
      binds = {
        cheatsheet.enable = true;
      };

      minimap = {
        minimap-vim.enable = false;
        codewindow.enable = false; # lighter, faster, and uses lua for configuration
      };

      notify = {
        nvim-notify.enable = true;
      };

      projects = {
        project-nvim.enable = false;
      };

      utility = {
        ccc.enable = false;
        vim-wakatime.enable = false;
        diffview-nvim.enable = true;
        yanky-nvim.enable = false;
        icon-picker.enable = false;
        surround.enable = false;
        leetcode-nvim.enable = false;
        multicursors.enable = false;
        smart-splits.enable = false;
        undotree.enable = false;
        nvim-biscuits.enable = false;

        motion = {
          hop.enable = true;
          leap.enable = true;
          precognition.enable = false;
        };

        images = {
          image-nvim.enable = false;
          img-clip.enable = false;
        };
      };

      notes = {
        obsidian.enable = false; # FIXME: neovim fails to build if obsidian is enabled
        neorg.enable = false;
        orgmode.enable = false;
        mind-nvim.enable = false;
        todo-comments.enable = false;
      };

      terminal = {
        toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = false; # the theme looks terrible with catppuccin
        illuminate.enable = true;
        breadcrumbs = {
          enable = false;
          navbuddy.enable = false;
        };

        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            # this is a freeform module, it's `buftype = int;` for configuring column position
            nix = "110";
            ruby = "120";
            java = "130";
            go = [
              "90"
              "130"
            ];
          };
        };

        fastaction.enable = true;
      };

      assistant = {
        chatgpt.enable = false;
        copilot = {
          enable = false;
          cmp.enable = false;
        };
        codecompanion-nvim.enable = false;
        avante-nvim.enable = false;
      };

      session = {
        nvim-session-manager.enable = false;
      };

      gestures = {
        gesture-nvim.enable = false;
      };

      comments = {
        comment-nvim.enable = true;
      };

      presence = {
        neocord.enable = false;
      };
    };
  };
}
