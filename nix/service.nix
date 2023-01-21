{
  config,
  lib,
  pkgs,
  ...
}: let
  hypixel-tracker = pkgs.callPackage ./package.nix {
    inherit pkgs;
  };

  cfg = config.services.hypixel-tracker;
in {
  options.services.hypixel-tracker.enable = lib.mkEnableOption "hypixel-tracker";

  config = lib.mkIf cfg.enable {
    systemd.timers.hypixel-tracker = {
      wantedBy = ["timers.target"];
      partOf = ["hypixel-tracker.service"];
      timerConfig.OnCalendar = ["*:0/1"];
    };

    systemd.services.hypixel-tracker = {
      serviceConfig = {
        Type = "oneshot";
        PrivateDevices = "true";
        ProtectKernelTunables = "true";
        ProtectKernelModules = "true";
        ProtectControlGroups = "true";
        RestrictAddressFamilies = "AF_INET AF_INET6";
        LockPersonality = "true";
        RestrictRealtime = "true";
        ExecStart = "${hypixel-tracker}/bin/main.py";
        User = "hypixel-tracker";
        Group = "hypixel-tracker";
      };
    };

    users.users.hypixel-tracker = {
      group = "hypixel-tracker";
      isSystemUser = true;
    };
    users.groups.hypixel-tracker = {};

    systemd.tmpfiles.rules = ["d /var/lib/hypixel-tracker 0700 hypixel-tracker root - -"];
  };
}
