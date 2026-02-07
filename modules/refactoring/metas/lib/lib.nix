{ lib, ... }:
{
  options.flake.meta.lib = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Project library functions";
  };
}
