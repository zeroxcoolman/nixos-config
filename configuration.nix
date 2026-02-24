{
  config,
  lib,
  pkgs,
  st-src,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # fuck nvidia
  nixpkgs.config.allowUnfree = true;

  # Use the GRUB EFI boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "crawlere30";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  security.doas.enable = true;
  security.doas.extraRules = [
    {
      users = [ "ehsab" ];
      persist = true;
      keepEnv = true;
    }
  ];

  security.sudo.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
  };

  nixpkgs.overlays = [
    (final: prev: {

      st = prev.st.overrideAttrs (old: {
        src = st-src;
        buildInputs = (old.buildInputs or [ ]) ++ [
          final.glib
          final.harfbuzz
          final.gd
        ];
        postPatch = ''
          rm -f config.h
        '';
      });
    })
  ];

  services.picom.enable = false;

  programs.fish.enable = true;

  services.flatpak.enable = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/.config/hypr/current_wallpaper 
    '';
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (old: {
          src = ./config/dwm;
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.imlib2 ];
        });
      };
    };
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.xserver.xkb.layout = "gb";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.libinput.enable = true;

  users.users.ehsab = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
  xdg.portal.config.common.default = "*";

  environment.systemPackages = with pkgs; [
    doas
    wget
    vim
    git
    fastfetch
    alacritty
    matugen
    picom
    xclip
    zoxide
    xmobar
    haskell-language-server
    gnumake
    kitty
    fish
    st
    cargo
    cava
    rofi
    satty
    brightnessctl
    wl-clipboard
    wtype
    xdotool
    nerd-fonts.jetbrains-mono
    btop
    acpi
    xrdb
    discord
    pokemon-colorscripts
    lsd
    dmenu
    fzf
    flatpak
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  system.stateVersion = "25.11";

}
