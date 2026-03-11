{
  perSystem =
    { config, pkgs, ... }:
    {
      devshells.ascend = {

        packages = with pkgs; [
          # build tools
          cmake
          ninja
          python3
          git

          # llvm
          lld
          lldb
          clang
          clang-tools
        ];

      };
    };
}
