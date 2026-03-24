{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  llvm = pkgs.llvmPackages_latest;
  python = pkgs.python311;

  codelldb-wrapper = pkgs.writeShellScriptBin "codelldb" ''
    # 指向 nixpkgs 中 vscode-lldb 插件安装目录下的 adapter 二进制文件
    exec ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
  '';
in
{
  packages = [
    # compile tools
    llvm.clang
    llvm.clang-tools
    llvm.llvm
    llvm.lld

    # python
    python

    # build tools
    pkgs.git
    pkgs.cmake
    pkgs.ninja
    pkgs.ccache
    pkgs.pkg-config

    # debug tools
    codelldb-wrapper
  ];

  env = {
    CC = "${llvm.clang}/bin/clang";
    CXX = "${llvm.clang}/bin/clang++";
    CMAKE_C_COMPILER = "${llvm.clang}/bin/clang";
    CMAKE_CXX_COMPILER = "${llvm.clang}/bin/clang++";
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
