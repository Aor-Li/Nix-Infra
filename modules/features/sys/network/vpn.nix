{ ... }:
let
  name = "feature/sys/network/vpn";
in 
{
  flake.modules.nixos.${name} = 
    { ... }:
    let 
      proxy = "http://127.0.0.1:10812";
    in
    {
      systemd.services.nix-daemon.environment = {
        http_proxy  = proxy;
        https_proxy = proxy;
        all_proxy   = proxy;
        no_proxy    = "127.0.0.1,localhost";

        # 有些程序只认大写（这点在 NixOS 生态里也踩过坑）
        HTTP_PROXY  = proxy;
        HTTPS_PROXY = proxy;
        ALL_PROXY   = proxy;
        NO_PROXY    = "127.0.0.1,localhost";
      };

    };
}
