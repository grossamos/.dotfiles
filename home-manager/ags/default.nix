{pkgs, ...}: {
  home.packages = with pkgs; [
    ags
    libdbusmenu-gtk3
  ];
}
