{ config, ... }:
{
  flake.aor.modules.feature.nix.conf = {
    home = {
      # devenv suggests Github access token for better connection
      # https://devenv.sh/getting-started/
      sops.templates."nix.conf" = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder.github_access_token}
        '';
        path = "${config.xdg.configHome}/nix/nix.conf";
      };
    };
  };
}
