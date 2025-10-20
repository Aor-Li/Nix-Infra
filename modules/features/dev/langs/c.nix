{ ... }:
let
  name = "feature/dev/langs/c";
in
{
  flake.modules.nixos.${name} =
    { pkgs, ... }:
    {
      # environment.systemPackages = with pkgs; [
      #   # compiler
      #   gcc15
      #   llvmPackages.clang
      #   llvmPackages.lld
      #   llvmPackages.libcxx

      #   # build tools
      #   cmake
      #   ninja
      #   gnumake
      #   pkg-config

      #   # debug tools
      #   gdb
      #   lldb
      # ];
    };
}
