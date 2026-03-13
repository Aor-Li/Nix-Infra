{
  perSystem =
    { config, pkgs, ... }:
    let
      python = pkgs.python3.withPackages (
        ps: with ps; [
          torch
          triton
        ]
      );
    in
    {
      devshells.ascend = {
        packages = [
          # build tools
          pkgs.cmake
          pkgs.ccache

          # llvm
          pkgs.llvmPackages_19.clang-tools
          pkgs.llvmPackages_19.clang
          pkgs.llvmPackages_19.lld
          pkgs.llvmPackages_19.lldb
          pkgs.llvmPackages_19.libcxx
          # pkgs.llvmPackages_19.libcxxabi

          python
        ];

        env = [
          {
            name = "LD_LIBRARY_PATH";
            value = "${pkgs.llvmPackages_19.libcxx.dev}/include/c++/v1";
          }
        ];

      };
    };
}
