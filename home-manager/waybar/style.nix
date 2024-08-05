{...}: {
  xdg.configFile."waybar/style.css".text = ''
    * {
        border-radius: 0;
        font-family: Roboto, Helvetica, Arial, sans-serif;
        color: white;
        min-height: 0;
    }
    window#waybar {
      padding-top: 5px;
      background: none;
    }
    .modules-left {
      margin-top: 10;
      margin-left: 10;
      font-size: 12;
      background-color: #141c2f;
      border-radius: 20;
      padding: 2 5;
    }

    .modules-center {
      margin-top: 10;
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20;
      font-size: 18;
      padding: 2 10;
    }
  '';
}
