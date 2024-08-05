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
      padding-top: 5px;
      background: none;
    }
    .modules-left {
      background-color: #141c2f;
      border-radius: 20px;
      padding: 2px 5px;
    }
  '';
}
