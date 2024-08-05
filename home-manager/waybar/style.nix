{...}: {
  xdg.configFile."waybar/style.css".text = ''
    * {
        border: none;
        border-radius: 0;
        font-family: Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
        color: white;
        min-height: 0;
    }
    window#waybar {
      background: none;
      border-bottom: 3px solid rgba(100, 114, 125, 0.5);
    }
  '';
}
