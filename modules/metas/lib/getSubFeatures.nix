{ lib }:
let
  # [TODO] 这个保留字段可以在feature-node定义时导出
  reserved = [
    "nixos"
    "home"
    "_meta"
  ];
in
{
  getSubFeatureNames =
    node:
    if node == null then [ ] else lib.filter (name: !(lib.elem name reserved)) (lib.attrNames node);
}
