{pkgs, ...}: {
  imports = [
    ./git
    ./gnome
    ./hyprland
	./notes.nix
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
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.neovim
    pkgs.ranger
    pkgs.tmux
    pkgs.fff
    pkgs.librewolf
    pkgs.teams-for-linux
    (pkgs.writeShellScriptBin "rebuild" ''
	  set -euxo pipefail
      pushd ~/.dotfiles
      git add .
      nix flake update
      git diff -U0 *.nix
      sudo nixos-rebuild switch --flake .
	  gen=$(nixos-rebuild list-generations | awk '$NF == "True" { print $1; exit }')
      git commit -m "$gen"
      git push
      popd
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nvim/init.lua".source = ../dotfiles/nvim/init.lua;
    ".tmux.conf".source = ../dotfiles/tmux/.tmux.conf;
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
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
	  initContent = ''
        bindkey -e
        bindkey '^R' history-incremental-search-backward

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;3D" backward-word

        bindkey -s '^[[2~' ""
      '';
    };
  };

  # ...
}
