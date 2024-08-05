{...}: {
  xdg.configFile."waybar/style.css".text = ''
    window.bottom_bar#waybar {
      background-color: rgba(1, 1, 1, 1)
      border: none;
    }
  '';
}
