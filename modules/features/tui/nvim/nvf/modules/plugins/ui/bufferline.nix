let
  name = "feature/tui/nvim/nvf";
  icons = {
    Error = " ";
    Warn = " ";
    Hint = " ";
    Info = " ";
  };
in
{
  flake.modules.homeManager.${name} =
    { lib, ... }:
    {
      # 仅启用与配置，不放键位
      programs.nvf.settings.vim.tabline.nvimBufferline = {
        enable = true;
        setupOpts = {
          options = {
            # TODO: lazyvim use snack.bufdelete to replace close_command and right_mouse_command
            diagnostics = "nvim_lsp";
            always_show_bufferline = true; # TODO
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
                  local icons = { Error = "${icons.Error}", Warn = "${icons.Warn}" }
                  local ret = ""
                  if diag.error then ret = ret .. icons.Error .. diag.error .. " " end
                  if diag.warning then ret = ret .. icons.Warn .. diag.warning end
                  return vim.trim(ret)
                end
              '';
            };

            get_element_icon = {
              _type = "lua-inline";
              expr = ''
                ---@param opts {filetype:string, path:string, extension:string}
                function(opts)
                  local ok, mi = pcall(require, "mini.icons")
                  if not ok then return nil end

                  -- 1) 先试 filetype
                  if opts.filetype and opts.filetype ~= "" then
                    local icon = (mi.get or function() end)("filetype", opts.filetype)
                    if type(icon) == "string" and icon ~= "" then return icon end
                    if type(icon) == "table" and icon.icon then return icon.icon end
                  end

                  -- 2) 再试扩展名
                  if opts.extension and opts.extension ~= "" then
                    local icon = (mi.get or function() end)("extension", opts.extension)
                    if type(icon) == "string" and icon ~= "" then return icon end
                    if type(icon) == "table" and icon.icon then return icon.icon end
                  end

                  -- 3) 最后按完整文件名
                  if opts.path and opts.path ~= "" then
                    local icon = (mi.get or function() end)("file", opts.path)
                    if type(icon) == "string" and icon ~= "" then return icon end
                    if type(icon) == "table" and icon.icon then return icon.icon end
                  end

                  return nil
                end
              '';
            };

          };
        };
      };
    };
}
