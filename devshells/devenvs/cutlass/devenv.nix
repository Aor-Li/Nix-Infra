{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  enterShell = ''
    clear
    fastfetch
  '';

  packages = [
    pkgs.cmake
    pkgs.python314
    pkgs.cudaPackages.cuda_cudart
    pkgs.cudaPackages.cudatoolkit
  ];

  env = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };

  scripts = {
    cm.exec = "cmake -S ./cutlass -B ./build -D CUTLASS_NVCC_ARCHS=\"80\" -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=On";
  };

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
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
