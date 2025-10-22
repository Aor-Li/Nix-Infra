{ ... }:
let
  name = "feature/dev/langs/c";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
    {
      # packages
      environment.systemPackages = with pkgs; [
        # lsp
        clang-tools

        # compiler
        gcc15
        llvmPackages.clang

        # build tools
        cmake
        ninja
        gnumake
        pkg-config

        # debug tools
        gdb
        ldb
      ];
    };
}
