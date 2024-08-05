{
  xdg.configFile."autostart/syncthing.decktop".text = ''
    [Desktop Entry]
    Name=syncthing
    GenericName=File Synchronizer
    Exec=syncthing
    Terminal=false
    Icon=Syncthing
    Categories=Network
    Type=Application
    StartupNotify=false
    X-GNOME-Autostart-enabled=true
    X-GNOME-Autostart-Delay=10
  '';
}
