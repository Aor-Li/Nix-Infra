{
  perSystem =
    { config, pkgs, ... }:
    let
      llvm = pkgs.llvmPackages_19;

      python = pkgs.python3.withPackages (
        ps: with ps; [
          torch
          triton
        ]
      );
    in
    {
      devshells.ascend = {

        devshell.stdenv = llvm.stdenv;

        packages = with pkgs; [
          # build tools
          git
          cmake
          ccache

          python

          # llvm
          llvm.stdenv
          llvm.libllvm
          llvm.lld
          llvm.lldb
          llvm.clang
          llvm.clang-tools
        ];

      };
    };
}
