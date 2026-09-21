{ pkgs, kagi, jail-nix, ... }:

let
  jail = jail-nix.lib.init pkgs;
  agentPkgs = [
    pkgs.bashInteractive
    pkgs.jq
    pkgs.git
    pkgs.gnugrep
    pkgs.diffutils
    kagi.packages.${pkgs.system}.default
  ];

  agentPermissions = with jail.combinators; [
    time-zone
    no-new-session
    mount-cwd
    network
    (readwrite (noescape "~/.pi/"))
    (add-pkg-deps agentPkgs)
  ];

  jailedPi = jail "pi" pkgs.pi-coding-agent agentPermissions;
in
{
  imports = [
    ./git
    ./gnome
    ./hyprland
    ./notes.nix
  ];

  home.username = "amos";
  home.homeDirectory = "/home/amos";
  home.stateVersion = "26.05";

  home.packages = [
    pkgs.neovim
    pkgs.ranger
    pkgs.tmux
    pkgs.librewolf
    pkgs.teams-for-linux
    kagi.packages.${pkgs.system}.default
    jailedPi

    (pkgs.writeShellScriptBin "rebuild" ''
      set -e
      pushd ~/.dotfiles
      git add .
      nix flake update
      git diff -U0 '*.nix'
      sudo nixos-rebuild switch --flake .
      gen=$(nixos-rebuild list-generations | awk '$NF == "True" { print $1; exit }')
      git commit -m "$gen"
      git push
      popd
    '')
  ];

  home.file = {
    ".config/nvim/init.lua".source = ../dotfiles/nvim/init.lua;
    ".tmux.conf".source = ../dotfiles/tmux/.tmux.conf;
    ".pi/agent/AGENTS.md".source = ../dotfiles/pi/AGENTS.md;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

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
        PS1="%B%F{green}%n@%m%f%b:%B%F{blue}%~%f%b "

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
}

