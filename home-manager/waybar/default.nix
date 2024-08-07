{pkgs, ...}: {
  imports = [
    ./style.nix
  ];
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
        "hyprland/workspaces#workspaces"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "hyprland/language#language"
        "network"
        "pulseaudio"
        "battery"
        "bluetooth"
        "custom/power"
      ];
      "hyprland/workspaces#workspaces" = {
        active-only = false;
        disable-scroll = true;
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          urgent = "";
          active = "";
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
      "battery" = {
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{capacity}% {icon}";
        "format-charging" = "{capacity}% ";
        "format-plugged" = "{capacity}% ";
        "format-alt" = "{time} {icon}";
        "format-icons" = ["" "" "" "" ""];
      };
      "hyprland/language#language" = {
        "format-en" = "en";
        "format-de" = "de";
        "keyboard-name" = "at-translated-set-2-keyboard";
        "on-click" = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
      };
      bluetooth = {
        "format" = "󰂯";
        "format-disabled" = "󰂲";
        "format-connected" = "󰂱 {device_alias}";
        "tooltip-format" = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected";
        "tooltip-format-disabled" = "bluetooth off";
        "tooltip-format-connected" = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected\n\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
        "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t({device_battery_percentage}%)";
        "max-length" = 35;
        "on-click" = "blueman-manager";
      };
      "custom/power" = {
        "return-type" = "json";
        exec = "echo '{ \"text\":\"󰐥\"}'";
        interval = "once";
        "on-click" = "shutdown now";
      };
      "pulseaudio" = {
        "states" = {
          "high" = 90;
          "upper-medium" = 70;
          "medium" = 50;
          "lower-medium" = 30;
          "low" = 10;
        };
        "tooltip-format" = "{desc}";
        "format" = "{icon} {volume}  {format_source}";
        "format-bluetooth" = "󰂱{icon} {volume}  {format_source}";
        "format-bluetooth-muted" = "󰂱󰝟 {volume}  {format_source}";
        "format-muted" = "󰝟 {volume}  {format_source}";
        "format-source" = "󰍬 {volume}%";
        "format-source-muted" = "󰍭 {volume}%";
        "format-icons" = {
          "headphone" = "󰋋";
          "hands-free" = "";
          "headset" = "󰋎";
          "phone" = "󰄜";
          "portable" = "󰦧";
          "car" = "󰄋";
          "speaker" = "󰓃";
          "hdmi" = "󰡁";
          "hifi" = "󰋌";
          "default" = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        "reverse-scrolling" = true;
        "reverse-mouse-scrolling" = true;
        "on-click" = "pavucontrol";
      };
      "network" = {
        "format" = "󰤭";
        "format-wifi" = "{icon}  ({signalStrength}%) {essid}";
        "format-icons" = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        "format-disconnected" = "󰤫 Disconnected";
        "tooltip-format" = "wifi <span color='#ee99a0'>off</span>";
        "tooltip-format-wifi" = "SSID: {essid}({signalStrength}%), {frequency} MHz\nInterface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\n\n<span color='#a6da95'>{bandwidthUpBits}</span>\t<span color='#ee99a0'>{bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹{bandwidthTotalBits}</span>";
        "tooltip-format-disconnected" = "<span color='#ed8796'>disconnected</span>";
        "format-ethernet" = "󰈀 {ipaddr}/{cidr}";
        "format-linked" = "󰈀 {ifname} (No IP)";
        "tooltip-format-ethernet" = "Interface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\nNetmask: {netmask}\nCIDR: {cidr}\n\n<span color='#a6da95'>{bandwidthUpBits}</span>\t<span color='#ee99a0'>{bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹{bandwidthTotalBits}</span>";
        "max-length" = 35;
        "on-click" = "kitty nmtui";
      };
    };
  };
}
