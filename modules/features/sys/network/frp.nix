{ ... }:
let
  name = "feature/sys/network/frp";
in
{
  flake.modules.nixos.${name} =
    {
      pkgs,
      lib,
      hostConfig,
      ...
    }:
    {
      # frp client service
      services.frp = lib.mkIf (hostConfig.name != "Bakotsu") {
        enable = true;
        role = "client";
        settings = {
          serverAddr = "your-server.com";
          serverPort = 7000;
          auth.token = "your-token";

          proxies = [
            {
              name = "ssh";
              type = "tcp";
              localIP = "127.0.0.1";
              localPort = 22;
              remotePort = 6000;
            }
          ];
        };
      };

      # frp client package
      environment.systemPackages = [ pkgs.frp ];
    };

  flake.modules.homeManager.${name} =
    { lib, hostConfig, ... }:
    {
      home.shellAliases = lib.mkIf (hostConfig.name != "Bakotsu") {
        frp-status = "sudo systemctl status frp";
        frp-restart = "sudo systemctl restart frp";
        frp-logs = "sudo journalctl -u frp -f";
      };
    };
}
