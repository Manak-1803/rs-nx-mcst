{ inputs, ... }: {
  flake.modules.nixos.sshd =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.sshd;
    in
    {
      options.rsnxmcst.sshd = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services.openssh = {
          enable = true;
          openFirewall = true;

          settings = {
            LogLevel = "VERBOSE";
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;

            MaxAuthTries = 3;
            ClientAliveCountMax = 3;
            ClientAliveInterval = 300;
          };
        };

        rsnxmcst.impermanence.files = [
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };
    };
}
