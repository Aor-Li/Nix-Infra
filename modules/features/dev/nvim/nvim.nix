{ config, lib, ... }:
let
  name = "feature/dev/nvim";
in
{
  options.flake.meta.modules.${name}.impl = lib.mkOption {
    type = lib.types.enum [ "nixvim" "nixcat" "nvf" ];
    default = "nvf";
    description = "The Neovim implementation to use.";
  };

  config.flake.meta.modules = 
    let
      impl = config.flake.meta.modules.${name}.impl;
    in {
      "${name}/${impl}".enable = true;
    };
}
