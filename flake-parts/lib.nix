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

      mkContainer =
        {
          module,
          address,
          bindMounts ? { },
          allowedDevices ? [ ],
        }:
        {
          autoStart = true;
          ephemeral = true;
          privateNetwork = true;
          hostBridge = "containers";
          localAddress = address;

          inherit bindMounts allowedDevices;

          config = lib.mkMerge [
            module

            {
              system.stateVersion = "26.11";
              services.resolved.enable = true;

              networking = {
                defaultGateway = "10.18.165.111";
                useHostResolvConf = lib.mkForce false;
              };
            }
          ];
        };
    };
  };
}
