# This shell if for AscendNPU-IR repo dev
{
  perSystem =
    { config, pkgs, ... }:
    let
      llvm = pkgs.llvmPackages_latest;
      clang = llvm.clang;

      python = pkgs.python311;

      # use gcc for needed includes and libs
      gccForLibs = pkgs.stdenv.cc.cc;
      gccLibDir = "${gccForLibs}/lib/gcc/${pkgs.stdenv.targetPlatform.config}/${gccForLibs.version}";
      glibcLibDir = "${pkgs.stdenv.cc.libc}/lib";
      glibcIncludeDir = "${pkgs.stdenv.cc.libc.dev}/include";
    in
    {
      devshells.ascend = {
        name = "AscendNPU-IR Devshell";

        packages = [
          # build essentials
          pkgs.cmake
          pkgs.ninja
          pkgs.ccache
          pkgs.pkg-config

          # debug
          pkgs.lldb

          # llvm
          (pkgs.lib.hiPrio clang)
          (pkgs.lib.lowPrio pkgs.gcc) # 提供gcc程序通过build.sh检查
          llvm.llvm
          llvm.lld

          # python
          python
        ];

        env = [
          {
            name = "CC";
            value = "${clang}/bin/clang";
          }
          {
            name = "CXX";
            value = "${clang}/bin/clang++";
          }
          {
            name = "CMAKE_C_COMPILER";
            value = "${clang}/bin/clang";
          }
          {
            name = "CMAKE_CXX_COMPILER";
            value = "${clang}/bin/clang++";
          }
          {
            name = "CMAKE_EXPORT_COMPILE_COMMANDS";
            value = "ON";
          }
          # 兜底：startup objects搜索路径
          {
            name = "NIX_CFLAGS_COMPILE";
            value = "-isystem ${glibcIncludeDir} -B${gccLibDir} -B${glibcLibDir}";
          }
          # 兜底：补 libgcc 搜索路径
          {
            name = "NIX_LDFLAGS";
            value = "-L${gccLibDir}";
          }
        ];

      };
    };
}
