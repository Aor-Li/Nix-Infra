{ inputs, ... }:
let
  name = "feature/tui/fastfetch";
in
{
  flake.modules = {
    nixos.${name} =
      { ... }:
      {
        imports = [ inputs.nixowos.nixosModules.default ];
        nixowos.enable = true;
      };

    homeManager.${name} =
      { ... }:
      {
        imports = [ inputs.nixowos.homeModules.default ];
        nixowos = {
          enable = true;
          overlays.enable = true;
        };
        programs.fastfetch = {
          enable = true;
          settings = {
            logo = {
              type = "builtin";
              height = 20;
              width = 20;
              padding = {
                top = 2;
                left = 3;
              };
            };
            modules = [
              "break"
              {
                type = "custom";
                format = "┌──────────────────────Hardware──────────────────────┐";
              }
              {
                type = "host";
                key = " PC";
                keyColor = "green";
              }
              {
                type = "cpu";
                key = "│ ├ ";
                keyColor = "green";
              }
              {
                type = "gpu";
                key = "│ ├󰍛 ";
                keyColor = "green";
              }
              {
                type = "memory";
                key = "│ ├󰍛 ";
                keyColor = "green";
              }
              {
                type = "disk";
                key = "└ └ ";
                keyColor = "green";
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────────────────┘";
              }
              "break"
              {
                type = "custom";
                format = "┌──────────────────────Software──────────────────────┐";
              }
              {
                type = "os";
                key = " OS";
                keyColor = "yellow";
              }
              {
                type = "kernel";
                key = "│ ├ ";
                keyColor = "yellow";
              }
              {
                type = "bios";
                key = "│ ├ ";
                keyColor = "yellow";
              }
              {
                type = "packages";
                key = "│ ├󰏖 ";
                keyColor = "yellow";
              }
              {
                type = "shell";
                key = "└ └ ";
                keyColor = "yellow";
              }
              "break"
              {
                type = "de";
                key = " DE";
                keyColor = "blue";
              }
              {
                type = "lm";
                key = "│ ├ ";
                keyColor = "blue";
              }
              {
                type = "wm";
                key = "│ ├ ";
                keyColor = "blue";
              }
              {
                type = "wmtheme";
                key = "│ ├󰉼 ";
                keyColor = "blue";
              }
              {
                type = "terminal";
                key = "└ └ ";
                keyColor = "blue";
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────────────────┘";
              }
              # "break"
              # {
              #   type = "custom";
              #   format = "┌────────────────────Uptime / Age / DT────────────────────┐";
              # }
              # {
              #   type = "command";
              #   key = "  OS Age ";
              #   keyColor = "magenta";
              #   text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
              # }
              # {
              #   type = "uptime";
              #   key = "  Uptime ";
              #   keyColor = "magenta";
              # }
              # {
              #   type = "datetime";
              #   key = "  DateTime ";
              #   keyColor = "magenta";
              # }
              # {
              #   type = "custom";
              #   format = "└─────────────────────────────────────────────────────────┘";
              # }
              {
                type = "colors";
                paddingLeft = 2;
                symbol = "circle";
              }
            ];
          };
        };
      };
  };
}
