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
      margin-top: 5;
      font-size: 12;
      background-color: #141c2f;
      border-radius: 20;
      padding: 2 5;
    }
  '';
}
