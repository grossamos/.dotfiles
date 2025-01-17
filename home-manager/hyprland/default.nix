{pkgs, ...}: {
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprshade.nix
    ../waybar
  ];
  home.packages = with pkgs; [
    rofi-wayland # application launcher
    hyprlock # lock screen
    hypridle
    dunst # notification deamon
    libnotify
    hyprshade
    swaybg # animated background
    pipewire
    wireplumber
    polkit_gnome # for passwd popup when apps elevate privliges
    nautilus
    pamixer
    playerctl
    brightnessctl
    blueman
    grim
    slurp
  ];

  xdg.portal.config.common.default = "*";

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    settings = {
      input = {
        kb_layout = "us,de";
        numlock_by_default = true;
        kb_options = "grp:win_space_toggle";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
        exec-once = [
          "hyprctl setcursor Adwaita 20 &"
          "waybar &"
          "swaybg -i ~/.dotfiles/images/background.jpg &"
          "syncthing serve --no-browser --logfile=default &"
          "hypridle &"
        ];
      };
      monitor = [
        ", preferred, auto, 1, mirror, eDP-1"
        "eDP-1,1920x1080@60,0x0,1"
      ];
      animations = {
        enabled = 0;
      };
      general = {
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        border_part_of_window = false;
        no_border_on_floating = false;
        "col.active_border" = "0xffe57c91";
        "col.inactive_border" = "0xffaeb690";
      };
      dwindle = {
        force_split = "2";
      };
      decoration = {
        rounding = 10;
      };

      "$mod" = "SUPER";
      bind =
        [
          "$mod SHIFT, return, exec, firefox"
          "$mod, return, exec, kitty"
          "$mod, mouse:272, movewindow"
          "$mod SHIFT, mouse:272, resizeactive"
          "$mod SHIFT, Escape, exec, hyprctl dispatch exit 1"
          "$mod SHIFT, R, exec, hyprctl reload"
          "$mod SHIFT, Q, killactive,"
          "$mod, Q, killactive,"
          "$mod, R, exec, rofi -show drun -theme arthur"
          "$mod, F, fullscreen,"
          "$mod, B, exec, hyprshade toggle ~/.config/hypr/hyprshade.glsl"
          "$mod, space , exec, hyprctl switchxkblayout at-translated-set-2-keyboard next"
          "$mod, Escape, exec, systemctl suspend"
          ", Print, exec, grim -g \"$(slurp)\" \"$HOME/Pictures/Screenshots/screenshot-$(date +'%Y-%m-%d--%H:%M:%S').png\""

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          ",XF86AudioRaiseVolume,exec, pamixer -i 5"
          ",XF86AudioLowerVolume,exec, pamixer -d 5"
          ",XF86AudioMute,exec, pamixer -t"
          ",XF86AudioPlay,exec, playerctl play-pause"
          ",XF86AudioNext,exec, playerctl next"
          ",XF86AudioPrev,exec, playerctl previous"
          ",XF86AudioStop, exec, playerctl stop"

          ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
          ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
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
