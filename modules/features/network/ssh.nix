{
  flake.aor.modules.feature.network.ssh = {
    nixos =
      { pkgs, ... }:
      {
        services.openssh.enable = true;
      };

    home = { ... }: { };
  };
}
