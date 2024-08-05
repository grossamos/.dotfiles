{
  xdg.configFile."autostart/syncthing.decktop".text = ''
    [Desktop Entry]
    Name=Syncthing Web UI
    GenericName=File synchronization UI
    Comment=Opens Syncthing's Web UI in the default browser (Syncthing must already be started).
    Exec=/etc/profiles/per-user/amos/bin/syncthing serve --no-browser --logfile=default
    Icon=syncthing
    Terminal=false
    Type=Application
    Keywords=synchronization;interface;
    Categories=Network;FileTransfer;P2P
  '';
}
