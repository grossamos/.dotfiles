# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.fwupd.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "lvim";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,de";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["amos"];

  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amos = {
    isNormalUser = true;
    description = "amos";
    extraGroups = ["networkmanager" "wheel" "adbusers" "docker"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  # rebuild-nix-script = pkgs.writeShellScriptBin "rebuild-nix" ''
  #    echo "rebuilding nix"
  #   push /etc/nixos/
  #  git add .
  # git commit -m
  # Note writeShellScriptBin vs writeScriptBin -- that'll put a hashbang to the current shell the first line
  # You can also put your bash code inline here, too, instead of loading a file
  # Note writeShellScriptBin vs writeScriptBin -- that'll put a hashbang to the current shell the first line
  # '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    steam-run
    # for my mouse
    openrazer-daemon
  ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerd-fonts.lilex
      nerd-fonts.martian-mono
      nerd-fonts.monaspace
      nerd-fonts.mplus
      nerd-fonts.fira-code
      nerd-fonts.inconsolata-lgc
      nerd-fonts.sauce-code-pro
      nerd-fonts.jetbrains-mono
      nerd-fonts._0xproto
      nerd-fonts.iosevka
      nerd-fonts._3270
      nerd-fonts.iosevka-term
      nerd-fonts.agave
      nerd-fonts.iosevka-term-slab
      nerd-fonts.anonymice
      nerd-fonts.jetbrains-mono
      nerd-fonts.arimo
      nerd-fonts.lekton
      nerd-fonts.aurulent-sans-mono
      nerd-fonts.liberation
      nerd-fonts.bigblue-terminal
      nerd-fonts.lilex
      nerd-fonts.bitstream-vera-sans-mono
      nerd-fonts.martian-mono
      nerd-fonts.blex-mono
      nerd-fonts.meslo-lg
      nerd-fonts.caskaydia-cove
      nerd-fonts.monaspace
      nerd-fonts.caskaydia-mono
      nerd-fonts.monofur
      nerd-fonts.code-new-roman
      nerd-fonts.monoid
      nerd-fonts.comic-shanns-mono
      nerd-fonts.mononoki
      nerd-fonts.commit-mono
      nerd-fonts.mplus
      nerd-fonts.cousine
      nerd-fonts.noto
      nerd-fonts.d2coding
      nerd-fonts.open-dyslexic
      nerd-fonts.daddy-time-mono
      # nerd-fonts.overpass
      nerd-fonts.dejavu-sans-mono
      # nerd-fonts.override
      # nerd-fonts.departure-mono
      # nerd-fonts.overrideDerivation
      # nerd-fonts.droid-sans-mono
      # nerd-fonts.profont
      # nerd-fonts.envy-code-r
      # nerd-fonts.proggy-clean-tt
      # nerd-fonts.fantasque-sans-mono
      # nerd-fonts.recurseForDerivations
      nerd-fonts.fira-code
      nerd-fonts.recursive-mono
      nerd-fonts.fira-mono
      # nerd-fonts.roboto-mono
      # nerd-fonts.geist-mono
      # nerd-fonts.sauce-code-pro
      nerd-fonts.go-mono
      nerd-fonts.shure-tech-mono
      nerd-fonts.gohufont
      nerd-fonts.space-mono
      nerd-fonts.hack
      nerd-fonts.symbols-only
      nerd-fonts.hasklug
      nerd-fonts.terminess-ttf
      nerd-fonts.heavy-data
      nerd-fonts.tinos
      nerd-fonts.hurmit
      nerd-fonts.ubuntu
      nerd-fonts.im-writing
      nerd-fonts.ubuntu-mono
      nerd-fonts.inconsolata
      nerd-fonts.ubuntu-sans
      nerd-fonts.inconsolata-go
      nerd-fonts.victor-mono
      nerd-fonts.inconsolata-lgc
      nerd-fonts.zed-mono
      nerd-fonts.intone-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  programs.adb.enable = true;

  networking.wireless.userControlled.enable = true;
  users.extraUsers.amos.extraGroups = ["wheel" "vboxusers" "kvm"];

  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # for ags, prolly can removed soon https://github.com/NixOS/nixpkgs/issues/306446
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.overlays = [
    (final: prev: {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [pkgs.libdbusmenu-gtk3];
      });
    })
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    xorg.libX11
    libpulseaudio
    libpng
  ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };
}
