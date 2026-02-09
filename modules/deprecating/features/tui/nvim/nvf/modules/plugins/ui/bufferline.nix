let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    { config, lib, ... }:
    let
      inherit (config) icons;
    in
    {
      # 仅启用与配置，不放键位
      programs.nvf.settings.vim.tabline.nvimBufferline = {
        enable = true;
        setupOpts = {
          options = {
            close_command = {
              _type = "lua-inline";
              expr = ''
                function(bufnr)
                  require("snacks.bufdelete").delete(bufnr)
                end
              '';
            };
            right_mouse_command = {
              _type = "lua-inline";
              expr = ''
                function(bufnr)
                  require("snacks.bufdelete").delete(bufnr)
                end
              '';
            };
            diagnostics = "nvim_lsp";
            always_show_bufferline = false;
            offsets = [
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                highlight = "Directory";
                text_align = "left";
              }
              {
                filetype = "snack_layout_box";
              }
            ];

            diagnostics_indicator = {
              _type = "lua-inline";
              expr = ''
                function(_, _, diag)
                  local icons = { Error = "${icons.diagnostics.Error}", Warn = "${icons.diagnostics.Warn}" }
                  local ret = ""
                  if diag.error then ret = ret .. icons.Error .. diag.error .. " " end
                  if diag.warning then ret = ret .. icons.Warn .. diag.warning end
                  return vim.trim(ret)
                end
              '';
            };

            # TODO: Default icon looked ugly, but I failed to apply mini.icons here
            # get_element_icon = ...
          };
        };
      };
    };
}
