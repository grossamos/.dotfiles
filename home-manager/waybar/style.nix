{...}: {
  xdg.configFile."waybar/style.css".text = ''
    * {
        border-radius: 0;
        font-family: Roboto, Helvetica, Arial, sans-serif;
        font-size: 15;
        color: white;
        min-height: 0;
    }
    window#waybar {
      background: none;
    }
    .modules-left {
      background-color: #002b36;
      border-radius: 20px;
      padding: 0 10px;
    }
  '';
}
