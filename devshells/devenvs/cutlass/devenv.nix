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
    pkgs.clang-tools
    pkgs.cmake
    pkgs.python314
    pkgs.cudaPackages.cuda_cudart
    pkgs.cudaPackages.cudatoolkit
  ];

  env = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };

  scripts = {
    cm.exec = "cmake -S ./cutlass -B ./build -D CUTLASS_NVCC_ARCHS=\"80\" -D CMAKE_BUILD_TYPE=Debug";
    generate-clangd.exec = ''
        rm -rf ./.clangd
        cat << 'EOF' > ./.clangd
        CompileFlags:
          Compiler: /usr/local/cuda/bin/nvcc
          Add:
            - -I/home/aor/infra/devshells/devenvs/cutlass/cutlass/include/
            - -I/home/aor/infra/devshells/devenvs/cutlass/cutlass/tools/util/include/
            - -I/home/aor/infra/devshells/devenvs/cutlass/cutlass/examples/common/

            - --cuda-path=${pkgs.cudaPackages.cudatoolkit}/bin/cuda
            - --cuda-gpu-arch=sm_80
            - -I${pkgs.cudaPackages.cudatoolkit}/include
            - "-xcuda"
            # report all errors
            - "-ferror-limit=0"
            - --cuda-gpu-arch=sm_80
            - --std=c++17
            - "-D__INTELLISENSE__"
            - "-D__CLANGD__"
            - "-DCUDA_12_0_SM80_FEATURES_SUPPORTED"
            - "-DCUTLASS_ARCH_MMA_SM80_SUPPORTED=1"
            - "-D_LIBCUDACXX_STD_VER=12"
            - "-D__CUDACC_VER_MAJOR__=12"
            - "-D__CUDACC_VER_MINOR__=3"
            - "-D__CUDA_ARCH__=800"
            - "-D__CUDA_ARCH_FEAT_SM80_ALL"
            - "-Wno-invalid-constexpr"
          Remove:
            # strip CUDA fatbin args
            - "-Xfatbin*"
            # strip CUDA arch flags
            - "-gencode*"
            - "--generate-code*"
            # strip CUDA flags unknown to clang
            - "-ccbin*"
            - "--compiler-options*"
            - "--expt-extended-lambda"
            - "--expt-relaxed-constexpr"
            - "-forward-unknown-to-host-compiler"
            - "-Werror=cross-execution-space-call"
        Hover:
          ShowAKA: No
        InlayHints:
          Enabled: No
        Diagnostics:
          Suppress:
            - "variadic_device_fn"
            - "attributes_not_allowed"
      EOF
    '';
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
