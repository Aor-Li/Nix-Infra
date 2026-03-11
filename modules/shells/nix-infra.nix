{
  # empty default shell for this repo
  perSystem =
    { config, pkgs, ... }:
    {
      devshells.default = { };
    };
}
