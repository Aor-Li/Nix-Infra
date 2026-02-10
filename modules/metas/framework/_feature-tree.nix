{ lib, ... }:
let
  inherit (lib) mkOption types;

  # ----------------------------
  # Type definitions
  # ----------------------------

  # Leaf impl type:
  # - Allows "defined in multiple places" merging
  # - Merges by producing a wrapper module with imports = all defs
  #
  # (null means "this feature has no impl of this type")
  implType = types.nullOr types.deferredModule;

  # Feature node schema:
  #   - fixed fields: nixos/home/part/_meta
  #   - everything else => sub-feature node (recursive)
  #
  # NOTE: we use a "description-decoupled" variant for recursion in freeformType
  # to avoid description self-recursion blow-ups in docs/errors.
  featureNodeType = types.submodule (
    { ... }:
    {
      options = {

        # Modules that implement the feature
        nixos = mkOption {
          type = implType;
          default = null;
        };
        home = mkOption {
          type = implType;
          default = null;
        };

        # Metadata
        _meta = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
      };

      # Anything else is a sub-feature node
      freeformType = types.attrsOf (featureNodeType // { description = "Feature node structure"; });
    }
  );

  # The whole feature tree is a map: name -> featureNode
  featureTreeType = types.attrsOf featureNodeType;

  # ----------------------------
  # Wiring: make each node's impl import its direct children's impls
  # ----------------------------

  moduleTypes = [
    "nixos"
    "home"
  ];

  isImplKey = k: builtins.elem k moduleTypes;
  isMetaKey = k: lib.hasPrefix "_" k; # includes _meta and internal keys like _module

  # null / module / [module...] -> [module...]
  asModuleList =
    v:
    if v == null then
      [ ]
    else if builtins.isList v then
      v
    else
      [ v ];

  wireNode =
    node:
    let
      # Children are: not an impl key, not a "_" key, and value is an attrset
      rawChildren = lib.filterAttrs (k: v: (!isImplKey k) && (!isMetaKey k) && builtins.isAttrs v) node;

      # Stable ordering => stable imports and predictable precedence
      childNames = lib.sort lib.lessThan (lib.attrNames rawChildren);

      # Recursively wire children first
      wiredChildren = lib.mapAttrs (_: wireNode) rawChildren;

      childImplsOf =
        type: lib.concatMap (name: asModuleList (wiredChildren.${name}.${type} or null)) childNames;

      # Build the wired impl for this node:
      # - if self impl exists, include it
      # - if children impls exist, include them
      # - produce a wrapper module only when needed; otherwise keep null
      mkWiredImpl =
        type:
        let
          own = asModuleList (node.${type} or null);
          kids = childImplsOf type;
        in
        if (own == [ ]) && (kids == [ ]) then null else { imports = own ++ kids; };

      rewiredImpls = lib.genAttrs moduleTypes mkWiredImpl;
    in
    # Preserve the node structure; override children with wired versions,
    # and override leaf impls with wired wrapper modules.
    node // wiredChildren // rewiredImpls;

  wireTree = tree: lib.mapAttrs (_: wireNode) tree;

in
{
  options.flake.aor.modules.feature = lib.mkOption {
    type = featureTreeType;
    default = { };
    description = "The feature tree with automatic dependency wiring.";

    # IMPORTANT: apply runs after all module definitions are merged.
    # Users write raw nodes; consumers read the wired tree.
    apply = wireTree;
  };
}
