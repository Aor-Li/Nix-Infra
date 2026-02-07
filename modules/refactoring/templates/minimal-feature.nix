# 这是一个最简单的功能模板
{ config, lib, ... }:
let
  inherit (config.flake.meta) namespace;
  path = [
    feature
    template
    foo
  ];
in
{
  flake.modules = {
    nixos = lib.setAttrByPath path (
      {
        config,
        lib,
        hostConfig,
        ...
      }:
      {
        options.namespace = lib.setAttrByPath path {
          enable = lib.mkEnableOption "Enable the template";
        };
        config = { };
      }
    );

    homeManager = lib.setAttrByPath path (
      {
        config,
        lib,
        userConfig,
        ...
      }:
      {
        options.namespace = lib.setAttrByPath path {
          enable = lib.mkEnableOption "Enable the template";
        };
        config = { };
      }
    );
  };
}
