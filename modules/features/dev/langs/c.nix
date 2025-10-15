{ ... }:
let
  name = "feature/dev/langs/c";
in
{
  flake.modules.nixos.${name} = 
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        
        # compiler
        gcc15

        llvmPackages_21.clang
        llvmPackages_21.lld
        llvmPackages_21.libcxx
        
        # build tools
        cmake
        ninja
        gnumake
        pkg-config

        # debug tools
        gdb
        lldb
      ];
    };
}
