{...}: {
  xdg.configFile."waybar/style.css".text = ''
    .modules-center {
      margin-top: 10;
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20;
      font-size: 18;
      padding: 2 20;
      font-weight: bold;
      color: #e6818d;
    }
    .modules-left {
      color: #ffffff;
      margin-top: 10;
      margin-left: 10;
      font-size: 15;
      background-color: #141c2f;
      border-radius: 20;
      padding: 2 5;
    }

    #hyprland-workspaces {
      color: #ffffff;
    }

    #custom-power {
      margin-left: 10;
      background-color: #141c2f;
      border-radius-left: 20;
      padding: 5 5 5 20;
    }

    .modules-right {
      color: #ffffff;
      margin-top: 10;
      font-size: 18;
    }

    window#waybar {
      background: none;
    }

    * {
        border-radius: 0;
        font-family: Roboto, Helvetica, Arial, sans-serif;
        min-height: 0;
    }

  '';
}
