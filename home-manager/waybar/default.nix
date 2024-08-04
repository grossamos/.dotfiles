{pkgs, ...}: {
  home.packages = with pkgs; [
    waybar
  ];
  programs.waybar = {
    settings.mainBar = {
      enable = true;
      position = "bottom";
      layer = "top";
      height = 5;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
    };
  };
}
