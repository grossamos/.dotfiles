{config, ...}: {
  xdg.configFile."autostart/syncthing_init.decktop".conf = {
    text = ''
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
    onChange = ''
      rm -f ${config.xdg.configHome}/autostart/syncthing.desktop
      cp ${config.xdg.configHome}/autostart/syncthing_init.desktop ${config.xdg.configHome}/autostart/syncthing.desktop
      chmod 644 ${config.xdg.configHome}/autostart/syncthing.desktop
    '';
  };
}
