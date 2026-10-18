{
  lib,
  self,
  inputs,
  ...
}:
{
  options.flake = {
    lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
  };

  config.flake = {
    lib = {
      mkOpt = type: default: lib.mkOption { inherit type default; };

      enableOpt = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      mkNixOS = name: {
        ${name} = inputs.nixpkgs.lib.nixosSystem {
          modules = [ self.modules.generic.${name} ] ++ (builtins.attrValues self.modules.nixos);
        };
      };
    };
  };
}
