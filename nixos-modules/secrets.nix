{ inputs, ... }: {
  flake.modules.nixos.secrets =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.secrets;

      hostKeys = { };

      hostKeyFile =
        if builtins.hasAttr config.networking.hostName hostKeys then
          pkgs.writeText "key.txt" hostKeys.${config.networking.hostName}
        else
          null;
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.rsnxmcst.secrets = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        sops = {
          defaultSopsFile = inputs.secrets + "/base.yaml";
          age =
            if builtins.hasAttr config.networking.hostName hostKeys then
              {
                plugins = with pkgs; [ age-plugin-tpm ];
                sshKeyPaths = lib.mkForce [ ];
                keyFile = "/var/lib/sops-nix/key.txt";
                generateKey = false;
              }
            else
              {
                sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                keyFile = "/var/lib/sops-nix/key.txt";
                generateKey = true;
              };
        };

        system.activationScripts = {
          setupSecrets.deps = [ "install-age-key" ];
          setupSecretsForUsers.deps = [ "install-age-key" ];

          install-age-key =
            let
              escapedHostFile = lib.escapeShellArg hostKeyFile;
              escapedKeyFile = lib.escapeShellArg config.sops.age.keyFile;
            in
            lib.mkIf (hostKeyFile != null) (
              lib.stringAfter [ "specialfs" ] ''
                if [[ ! -f ${escapedKeyFile} ]]; then
                  install -Dm0600 ${escapedHostFile} ${escapedKeyFile}
                fi
              ''
            );
        };
      };
    };
}
