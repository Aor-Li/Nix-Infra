{
  flake.aor.modules.feature.dev.langs.clang = {
    home =
      { pkgs, ... }:
      let
        llvm = pkgs.llvmPackages_latest;
      in
      {
        home.packages = [
          llvm.clang
          llvm.clang-tools
          llvm.llvm
          llvm.lld

          pkgs.gcc
          pkgs.cmake
          pkgs.ninja
          pkgs.pkg-config
        ];

        home.sessionVariables = {
          CC = "${llvm.clang}/bin/clang";
          CXX = "${llvm.clang}/bin/clang++";
        };
      };
  };
}
