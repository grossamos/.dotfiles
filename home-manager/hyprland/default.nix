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
    nautilus
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
          "hyprlock &"
          "swww-daemon &"
          "swww img ~/.dotfiles/images/background.jpg"
          "waybar"
        ];
      };
      monitor = "eDP-1,1920x1080@60,0x0,1";
      animations = {
        enabled = 0;
      };
      "$mod" = "SUPER";
      bind =
        [
          "SUPER_SHIFT, return, exec, firefox"
          "SUPER, return, exec, kitty"
          "SUPER_SHIFT, Escape, exec, hyprctl dispatch exit 1"
          "SUPER_SHIFT, R, exec, hyprctl reload"
          ", Print, exec, grimblast copy area"
          "$mod, Escape, exec, swaylock"
          "$mod, Q, killactive,"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
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
