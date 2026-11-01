{ inputs, ... }: {
  flake.modules.nixos.forgejo =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.forgejo;
    in
    {
      options.rsnxmcst.forgejo = {
        enable = inputs.self.lib.enableOpt;
        userDatabases = inputs.self.lib.mkOpt (with lib.types; listOf str) [ ];
      };

      config = lib.mkIf cfg.enable {
        containers.forgejo = inputs.self.lib.mkContainer {
          address = "10.18.219.167/16";

          bindMounts = {
            "/var/lib/forgejo" = {
              hostPath = "/var/lib/forgejo";
              isReadOnly = false;
            };

            "/etc/forgejo/mailer-passwd" = {
              hostPath = config.sops.secrets.forgejo-mailer.path;
              isReadOnly = true;
            };
          };

          module = {
            networking.firewall.allowedTCPPorts = [
              22
              3000
            ];

            services.forgejo = {
              enable = true;
              lfs.enable = true;

              database = {
                createDatabase = false;
                type = "postgres";
                host = "10.18.30.62";
                port = 5432;
                user = "forgejo";
                name = "forgejo";
              };

              settings = {
                service.DISABLE_REGISTRATION = true;

                server = {
                  HTTP_PORT = 3000;
                  HTTP_ADDR = "0.0.0.0";
                  ROOT_URL = "https://git.rsnxmcst.dedyn.io/";
                  DOMAIN = "git.rsnxmcst.dedyn.io";

                  START_SSH_SERVER = true;
                  SSH_DOMAIN = "git.rsnxmcst.dedyn.io";
                };

                mailer = {
                  ENABLED = true;
                  SMTP_ADDR = "smtp.email.ap-hyderabad-1.oci.oraclecloud.com";
                  SMTP_PORT = 587;
                  USER = "ocid1.user.oc1..aaaaaaaabft6uffde434jnyw7ussyrtfpl55v77kkcc2v6d2vukcg6pvflwq@ocid1.tenancy.oc1..aaaaaaaa4kojmbcrluinjhlacadoee4mj2nug734eidjwjorg36xtplgl4ma.4c.com";
                  FROM = "git@rsnxmcst.dedyn.io";
                };
              };

              secrets = {
                mailer.PASSWD = "/etc/forgejo/mailer-passwd";
              };
            };
          };
        };

        sops.secrets.forgejo-mailer = { };
        
        rsnxmcst = {
          impermanence.directories = [ "/var/lib/forgejo" ];
          postgresql.userDatabases = [ "forgejo" ];
        };
      };
    };
}
