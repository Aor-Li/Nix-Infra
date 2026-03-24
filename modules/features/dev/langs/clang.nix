{
  flake.aor.modules.feature.dev.langs.clang = {
    home =
      { pkgs, ... }:
      let
        llvm = pkgs.llvmPackages_latest;
        codelldb-wrapper = pkgs.writeShellScriptBin "codelldb" ''
          # 指向 nixpkgs 中 vscode-lldb 插件安装目录下的 adapter 二进制文件
          exec ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
        '';
        queryDrivers = "/nix/store/*-gcc-*/bin/g++,/nix/store/*-gcc-*/bin/gcc,/nix/store/*-clang-wrapper-*/bin/clang++,/nix/store/*-clang-wrapper-*/bin/clang";
      in
      {
        home.packages = [
          (pkgs.lib.hiPrio llvm.clang)
          (pkgs.lib.lowPrio pkgs.gcc)

          llvm.clang-tools
          llvm.llvm
          llvm.lld

          # build tools
          pkgs.cmake
          pkgs.ninja
          pkgs.gnumake
          pkgs.pkg-config
          pkgs.ccache

          # debug tools
          codelldb-wrapper
          pkgs.gdb
          pkgs.lldb
          pkgs.rr

          # others
          pkgs.binutils
        ];

        home.sessionVariables = {
          # use llvm tools by default
          CC = "${llvm.clang}/bin/clang";
          CXX = "${llvm.clang}/bin/clang++";
          AR = "${llvm.llvm}/bin/llvm-ar";
          AS = "${llvm.llvm}/bin/llvm-as";
          NM = "${llvm.llvm}/bin/llvm-nm";
          RANLIB = "${llvm.llvm}/bin/llvm-ranlib";
          STRIP = "${llvm.llvm}/bin/llvm-strip";
          OBJCOPY = "${llvm.llvm}/bin/llvm-objcopy";
          OBJDUMP = "${llvm.llvm}/bin/llvm-objdump";
          LD = "${llvm.lld}/bin/ld.lld";

          CLANGD_FLAGS = "--query-driver=${queryDrivers} --background-index";
        };

        xdg.configFile."clangd/config.yaml".text = ''
          CompileFlags:
            Compiler: ${llvm.clang}/bin/clang++
            CompilationDatabase: Ancestors

            # 可选：如果你想让 builtin headers 也来自 query-driver（有风险，clangd 文档有警告）
            # BuiltinHeaders: QueryDriver
        '';

      };
  };
}
