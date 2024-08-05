{...}: {
  xdg.configFile."waybar/style.css".text = ''
    * {
        border-radius: 0;
        font-family: Roboto, Helvetica, Arial, sans-serif;
        font-size: 20;
        color: white;
        min-height: 0;
    }
    window#waybar {
      background: none;
    }
    .modules-left {
      background-color: #586e75;
      border-radius: 20px;
    }
  '';
}
