{ config, pkgs, ... }:

{

  systemd.user.services.picom = {
    Unit = {
      Description = "Picom compositor";
      ConditionPathExists = "/tmp/.X11-unix/X0";
      After = [ "graphical-session-pre.target" ];
      Wants = [ "graphical-session-pre.target" ];
    };

    Service = {
      ExecStart = "${pkgs.picom}/bin/picom --config ${config.home.homeDirectory}/.config/picom/picom.conf";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
