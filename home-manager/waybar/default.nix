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
        "hyprland/language"
        "network"
        "pulseaudio"
        "battery"
        "custom/logout_menu"
      ];
      "hyprland/workspaces" = {
        active-only = false;
        disable-scroll = true;
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          urgent = "";
          active = "⬤";
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
      clock = {
        format = "{:%H:%M}";
        locale = "en_US.UTF-8";
      };
      "hyprland/language" = {
        "format-en" = "en";
        "format-de" = "de";
        "keyboard-name" = "at-translated-set-2-keyboard";
        "on-click" = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
      };
      "custom/logout_menu" = {
        "return-type" = "json";
        exec = "echo '{ \"text\":\"󰐥\", \"tooltip\": \"logout menu\" }'";
        interval = "once";
        "on-click" = "shutdown now";
      };
    };
  };
}
