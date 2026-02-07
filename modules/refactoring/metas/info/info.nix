{ config, lib, ... }:
{
  options.flake.meta = {

    root = lib.mkOption {
      type = lib.types.string;
      default = "~/infra";
      description = "Root directory of the project.";
    };

    namespace = lib.mkOption {
      type = lib.types.string;
      default = "aor";
      description = "Root namespace of this flake";
    };

  };
}
