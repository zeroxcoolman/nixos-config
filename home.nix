{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/mydotfilesprivate/";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    rofi = "rofi";
    kitty = "kitty";
    picom = "picom";
    waybar = "waybar";
    swaync = "swaync";
  };
in

{
  imports = [
    ./modules/picom.nix
  ];

  home.username = "ehsab";
  home.homeDirectory = "/home/ehsab";
  home.stateVersion = "25.11";

  programs.bash = {
    enable = true;
    shellAliases = {
      test = "echo test";
      nrs = "sudo nixos-rebuild switch";
    };

    initExtra = ''
      		  export PS1='\[\e[38;5;51m\]\u\[\e[0m\]@\h  \[\e[38;5;123m\]\w\[\e[0m\] '
      		 '';
  };
  home.sessionPath = [
    "/home/ehsab/.local/bin"
  ];

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.packages = with pkgs; [
    ripgrep
    neovim
    nil
    nixpkgs-fmt
    nodejs
    gcc
    bat
    rofi
    xwallpaper
  ];

}
