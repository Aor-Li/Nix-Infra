{
  flake.aor.modules.feature.network.tailscale = {
    nixos =
      { pkgs, ... }:
      {
        # [HACK] 有需要再启用
        services.tailscale.enable = false;
      };
  };
}
