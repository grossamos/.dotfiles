{...}: {
  xdg.configFile."waybar/style.css".text = ''
    .modules-center {
      margin-top: 10;
      margin-left: 10;
      background-color: #141c2f;
      color: #9fb08f;
      border-radius: 20;
      font-size: 18;
      padding: 2 20;
      font-weight: bold;
    }

    #workspaces {
      margin-top: 10;
      margin-left: 10;
      font-size: 15;
      background-color: #141c2f;
      border-radius: 20;
      padding: 2 5;
    }

    #workspaces > button {
      color: #ffffff;
    }

    #custom-power {
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20 0 0 20;
      padding: 5 20 5 15;
      color: #e6818d;
    }

    #bluetooth {
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20 0 0 20;
      padding: 5 20 5 15;
      color: #388f9b;
    }

    #battery {
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20;
      padding: 5 20 5 20;
      color: #9fb08f;
    }

    #pulseaudio {
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20;
      padding: 5 20 5 20;
      color: #ffffff;
    }

    #network {
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20;
      padding: 5 20 5 20;
      color: #50D5D5;
    }

    #language {
      margin-left: 10;
      background-color: #141c2f;
      border-radius: 20;
      padding: 5 20 5 20;
      color: #ffffff;
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
