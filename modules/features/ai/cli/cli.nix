{
  flake.aor.modules.feature.ai.cli = {
    nixos = { ... }: { };

    home =
      { config, ... }:
      {
        config.aor.modules.feature.ai.cli.claude = {
          enable = true;
          provider = "Clauddy";
        };
      };
  };
}
