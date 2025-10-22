{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  enterShell = ''
    clear
    fastfetch
  '';

  packages = [
    pkgs.clang-tools
    pkgs.gcc15

    pkgs.cmake
    pkgs.ninja
    pkgs.gnumake

    pkgs.cudaPackages.cuda_cudart
    pkgs.cudaPackages.cudatoolkit

    pkgs.liburing
  ];

  env = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };

  scripts = {
    "cm".exec = "cmake -S ./less_slow.cpp -B ./build -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=On";
    "mi".exec = "cmake --build ./build --config Release";
  };

  tasks = {
    "test:all" = {
      exec = "./build/less_slow";
    };
  };
}
