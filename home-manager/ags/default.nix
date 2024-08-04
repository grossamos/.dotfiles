{pkgs, ...}: {
  home.packages = with pkgs; [
    ags
    libdbusmenu-gtk3
  ];

  xdg.configFile."ags/config.js".source = ./config.js;
  xdg.configFile."ags/tsconfig.json".source = ./tsconfig.json;
  xdg.configFile."ags/style.css".source = ./style.css;
}
