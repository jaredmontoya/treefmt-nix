{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.goimports-reviser;
in
{
  meta.maintainers = [ "jaredmontoya" ];

  imports = [
    (mkFormatterModule {
      name = "goimports-reviser";
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    })
  ];

  options.programs.goimports-reviser = {
    format = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to perform additional formatting.
      '';
    };

    imports-order = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "std,general,company,project";
      description = ''
        A sequence describing imports sorting order.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.goimports-reviser = {
      options =
        lib.optional cfg.format "-format"
        ++ lib.optionals (cfg.imports-order != null) [
          "-imports-order"
          cfg.imports-order
        ];
    };
  };
}
