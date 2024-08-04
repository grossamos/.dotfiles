{pkgs, ...}: {
  home.packages = with pkgs; [
    waybar
  ];
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      enable = true;
      position = "top";
      layer = "top";
      height = 5;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      modules-left = [
        "custom/launcher"
        "hyprland/workspaces"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "custom/notification"
      ];
      "hyprland/workspaces" = {
        active-only = false;
        disable-scroll = true;
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          urgent = "";
          active = "";
          default = "";
          empty = "";
        };
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
          "6" = [];
          "7" = [];
          "8" = [];
          "9" = [];
          "10" = [];
        };
      };
    };
  };
}
