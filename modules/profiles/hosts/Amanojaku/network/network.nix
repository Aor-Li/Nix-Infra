{
  flake.aor.modules.profile.host.Amanojaku = {

    # proxy
    aor.modules.feature.network.vpn = {
      enable = true;
      proxy = "http://127.0.0.1:7897";
      no_proxy = "127.0.0.1,localhost,.localdomain";
    };
  };
}
