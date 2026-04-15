{
  perSystem =
    { pkgs, lib, ... }:
    {
      devenv.shells.ascend-devenv = {
        packages = lib.mkBefore [
          pkgs.clang-tools
          pkgs.cmake
          pkgs.ninja
          pkgs.bear
          pkgs.ccache
        ];

        languages = {
          cplusplus = {
            enable = true;
            lsp.enable = true;
          };
          python = {
            enable = true;
            uv.enable = true;
            lsp.enable = true;
          };
        };
      };
    };
}
