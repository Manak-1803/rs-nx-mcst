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

      hostKeys = {
        nocturne = "AGE-PLUGIN-TPM-1QGQQQKQQYVQQKQQZQPEQQQQQZQQPJQQTQQPSQYQQYZUV5TDA85LM9U2SPJCZDVHGAEW9JPJSN9TMKWXWK3RLDJ8LM082VQPQWWWTMTJ9ELQXUDWDH6F536J3C9UA0UGFVPY3D2GJKRYLJNJS8YQSQLSQYRGM6AQQ2KMHQH90GFV7MTZLYH8T9RY93UM2GF049DZTZDXGGMNGWQQSNQWU6UQR5R27VEEFPJ0E3TG5XYGP0EN0292LVJN2TJFW7JM4WUJPY33YK4QDXX3SF658ZYKZD2S9N0HK4WN8T62YP3P0U6CP028Q7UQ9NPZSS5M78ULAVYC5677WS0ZF7QLC0RX5USPHLXYEQQ3QQZ7RHKHMLM2KLHEV8XPF4U0MNE2ZUT4PYMSZZY4Z40PR7G9EAN7VSS8YNEMP";
      };

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
