{...}: {
  xdg.configFile."waybar/style.css".text = ''
    window#waybar {
      background-color: red;
      border-bottom: 3px solid rgba(100, 114, 125, 0.5);
    }
  '';
}
