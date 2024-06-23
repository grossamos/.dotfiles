{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../git
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "amos";
  home.homeDirectory = "/home/amos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.neofetch
    pkgs.ungoogled-chromium
    pkgs.ranger
    pkgs.postman
    pkgs.dconf
    pkgs.python312Packages.openrazer
    pkgs.spotify
    pkgs.alejandra
    pkgs.protonvpn-gui
    pkgs.wireshark
    pkgs.gnome.dconf-editor
    pkgs.lunarvim
    (pkgs.writeShellScriptBin "rebuild" ''
      set -e
      pushd ~/.dotfiles
      alejandra . &>/dev/null
      git diff -U0 *.nix
      sudo nixos-rebuild switch --flake .
      gen=$(nixos-rebuild list-generations | grep current)
      git commit -am "$gen"
      git push
      popd
    '')
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/amos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "lvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
  };

  # ...
  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/pills-l.jxl";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/pills-d.jxl";
    };
    "org/gnome/desktop/wm/keybindings" = {
      "switch-to-workspace-1" = ["<Super>1"];
      "switch-to-workspace-2" = ["<Super>2"];
      "switch-to-workspace-3" = ["<Super>3"];
      "switch-to-workspace-4" = ["<Super>4"];
      "switch-to-workspace-5" = ["<Super>5"];
      "switch-to-workspace-6" = ["<Super>6"];
      "switch-to-workspace-7" = ["<Super>7"];
      "switch-to-workspace-8" = ["<Super>8"];
      "switch-to-workspace-9" = ["<Super>9"];
      "move-to-workspace-left" = ["<Super><Shift>Left"];
      "move-to-workspace-right" = ["<Super><Shift>Right"];
      "switch-to-workspace-left" = ["<Super>Left"];
      "switch-to-workspace-right" = ["<Super>Right"];
      "open-terminal" = ["<Super>Return"];
      "open-browser" = ["<Super>+<Shift>Return"];
      "close" = ["disabled"];
      "minimize" = ["disabled"];
      "toggle-maximized" = ["disabled"];
      "show-desktop" = ["disabled"];
      "panel-main-menu" = ["disabled"];
      "switch-to-application-1" = ["disabled"];
      "switch-to-application-2" = ["disabled"];
      "switch-to-application-3" = ["disabled"];
      "switch-to-application-4" = ["disabled"];
      "switch-to-application-5" = ["disabled"];
      "switch-to-application-6" = ["disabled"];
      "switch-to-application-7" = ["disabled"];
      "switch-to-application-8" = ["disabled"];
      "switch-to-application-9" = ["disabled"];
    };
    "org.gnome.mutter.keybindings" = {
      toggle-tiled-left = ["<Super><Alt>Left"];
      toggle-tiled-right = ["<Super><Alt>Right"];
    };
    "org/gnome/desktop/applications/browser" = {
      exec = "firefox";
    };
  };
}
