{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.saber-cursor;
in
{
  options.programs.saber-cursor = {
    enable = lib.mkEnableOption "Enables saber cursor.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      description = "The cursor theme package to use. (default to self)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Home config
    home.packages = [ cfg.package ];
    home.file.".local/share/icons/saber-cursor".source = "${cfg.package}/share/icons/saber-cursor";

    # Setting up plasma cursor
    programs.plasma.workspace.cursor = {
      cursorFeedback = "Bouncing";
      size = 48;
      theme = "Saber Icon theme";
      taskManagerFeedback = true;
      animationTime = 5;
    };
  };
}
