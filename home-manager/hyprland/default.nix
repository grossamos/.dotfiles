{pkgs, ...}: {
  home.packages = with pkgs; [
    rofi-wayland # application launcher
    hyprlock # lock screen
    waybar # top bar
    dunst # notification deamon
    kitty
    libnotify
    swww # animated background
    pipewire
    wireplumber
    polkit_gnome # for passwd popup when apps elevate privliges
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    settings = {
      input = {
        kb_layout = "us,de";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
        exec-once = [
          "systemctl --user import-environment &"
          "hash dbus-update-activation-environment 2>/dev/null &"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
          "nm-applet &"
          "wl-clip-persist --clipboard both"
          "swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f) &"
          "hyprctl setcursor Nordzy-cursors 22 &"
          "poweralertd &"
          "waybar &"
          "swaync &"
          "wl-paste --watch cliphist store &"
          "hyprlock"
        ];
      };
      monitor = "eDP-1,1920x1080@60,0x0,1";
      "$mod" = "SUPER";
      bind =
        [
          "SUPER_SHIFT, return, exec, firefox"
          "SUPER, return, exec, kitty"
          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };
}
