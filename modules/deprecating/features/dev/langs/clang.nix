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
        # compiler
        gcc
        llvmPackages.clang

        # lsp
        llvmPackages.clang-tools

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

  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      xdg.configFile."clangd/config.yaml".text = ''
        CompileFlags:
          CompilationDatabase: Ancestors
          BuiltinHeaders: QueryDriver
      '';
    };
}
