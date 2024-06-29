{...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Console.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/pills-l.jxl";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/pills-d.jxl";
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-left = ["<Super>Left"];
      switch-to-workspace-right = ["<Super>right"];
    };
    "org/gnome/mutter/keybindings/toggle-tiled-left" = {
      toggle-tiled-left = ["<Super>j"];
      toggle-tiled-right = ["Super>k"];
    };
  };
  #   "org/gnome/desktop/wm/keybindings" = {
  #     "switch-to-workspace-1" = ["<Super>1"];
  #     "switch-to-workspace-2" = ["<Super>2"];
  #     "switch-to-workspace-3" = ["<Super>3"];
  #     "switch-to-workspace-4" = ["<Super>4"];
  #     "switch-to-workspace-5" = ["<Super>5"];
  #     "switch-to-workspace-6" = ["<Super>6"];
  #     "switch-to-workspace-7" = ["<Super>7"];
  #     "switch-to-workspace-8" = ["<Super>8"];
  #     "switch-to-workspace-9" = ["<Super>9"];
  #     "move-to-workspace-left" = ["<Super><Shift>Left"];
  #     "move-to-workspace-right" = ["<Super><Shift>Right"];
  #     "switch-to-workspace-left" = ["<Super>Left"];
  #     "switch-to-workspace-right" = ["<Super>Right"];
  #     "open-terminal" = ["<Super>Return"];
  #     "open-browser" = ["<Super>+<Shift>Return"];
  #     "close" = ["disabled"];
  #     "minimize" = ["disabled"];
  #     "toggle-maximized" = ["disabled"];
  #     "show-desktop" = ["disabled"];
  #     "panel-main-menu" = ["disabled"];
  #     "switch-to-application-1" = ["disabled"];
  #     "switch-to-application-2" = ["disabled"];
  #     "switch-to-application-3" = ["disabled"];
  #     "switch-to-application-4" = ["disabled"];
  #     "switch-to-application-5" = ["disabled"];
  #     "switch-to-application-6" = ["disabled"];
  #     "switch-to-application-7" = ["disabled"];
  #     "switch-to-application-8" = ["disabled"];
  #     "switch-to-application-9" = ["disabled"];
  #   };
  #   "org.gnome.mutter.keybindings" = {
  #     toggle-tiled-left = ["<Super><Alt>Left"];
  #     toggle-tiled-right = ["<Super><Alt>Right"];
  #   };
  #   "org/gnome/desktop/applications/browser" = {
  #     exec = "firefox";
  #   };
  # };
}
