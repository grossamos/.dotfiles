{
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [pkgs.libdbusmenu-gtk3];
      });
    })
  ];
  xdg.configFile."ags/config.js".source = ./config.js;
  xdg.configFile."ags/tsconfig.json".source = ./tsconfig.json;
  xdg.configFile."ags/style.css".source = ./style.css;
}
