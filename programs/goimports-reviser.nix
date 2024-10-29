{ lib, pkgs, config, ... }:
let
  cfg = config.programs.goimports-reviser;
in
{
  meta.maintainers = [ "jaredmontoya" ];

  options.programs.goimports-reviser = {
    enable = lib.mkEnableOption "goimports-reviser";
    package = lib.mkPackageOption pkgs "goimports-reviser" { };
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
      command = cfg.package;
      options =
        lib.optional cfg.format "-format"
        ++ lib.optional (cfg.imports-order != null) ''-imports-order "${cfg.imports-order}"'';
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    };
  };
}
