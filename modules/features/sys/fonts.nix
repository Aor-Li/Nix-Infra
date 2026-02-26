{
  flake.aor.modules.feature.sys.fonts = {
    nixos =
      { lib, pkgs, ... }:
      {
        # provide basic font supports
        fonts.enableDefaultPackages = lib.mkDefault true;

        fonts.packages = with pkgs; [
          # notos
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji

          # nerd-fonts
          nerd-fonts.monaspace
          nerd-fonts.caskaydia-cove
          maple-mono.NF-CN

          nerd-fonts.jetbrains-mono
          sarasa-gothic

        ];

        fonts.fontconfig = {
          enable = true;
          # allow user to override system fonts
          includeUserConf = true;

          defaultFonts = {
            serif = lib.mkDefault [
              "Noto Serif CJK SC"
              "Noto Serif"
            ];
            sansSerif = lib.mkDefault [
              "Noto Sans CJK SC"
              "Noto Sans"
            ];
            monospace = lib.mkDefault [
              "Jetbrains Mono"
              "Sarasa Mono SC"
            ];
            emoji = lib.mkDefault [
              "Noto Color Emoji"
            ];
          };
        };
      };

    home =
      { lib, pkgs, ... }:
      {
        home.packages = with pkgs; [
          nerd-fonts.comic-shanns-mono
          lxgw-fusionkai
        ];
        fonts.fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [
              "Comic Shanns Mono NF"
              "fusionkai Mono NF"
            ];
          };
        };
      };
  };
}
