{ inputs, ... }: {
  flake.modules.homeManager.impermanence =
    {
      lib,
      config,
      options,
      ...
    }:
    let
      cfg = config.rsnxmcst.impermanence;

      directories = map (
        item: item // { directory = lib.strings.removePrefix config.home.homeDirectory item.directory; }
      ) cfg.directories;

      files = map (
        item: item // { file = lib.strings.removePrefix config.home.homeDirectory item.file; }
      ) cfg.files;
    in
    {
      options.rsnxmcst.impermanence = {
        enable = inputs.self.lib.enableOpt;
        storagePath = inputs.self.lib.mkOpt lib.types.str "/persist";

        directories = inputs.self.lib.mkOpt (
          with lib.types; listOf (coercedTo str (path: { directory = path; }) attrs)
        ) [ ];

        files = inputs.self.lib.mkOpt (
          with lib.types; listOf (coercedTo str (path: { file = path; }) attrs)
        ) [ ];
      };

      config = lib.optionalAttrs (options.home ? persistence) (
        lib.mkIf cfg.enable {
          home.persistence."${cfg.storagePath}" = {
            inherit directories files;
            hideMounts = true;
          };
        }
      );
    };
}
