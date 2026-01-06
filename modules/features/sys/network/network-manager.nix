{ ... }:
let
  name = "feature/sys/network/network-manager";
in
{
  flake.modules.nixos.${name} =
    { hostConfig, lib, ... }:
    {
      # wsl下使用wpa构建会报错（也可能时其它原因）
      networking.networkmanager.enable = lib.mkIf (hostConfig.type != "wsl") true;

      # wsl中使用IPv6连接存在问题
      networking.enableIPv6 = lib.mkIf (hostConfig.type == "wsl") false;
    };
}
