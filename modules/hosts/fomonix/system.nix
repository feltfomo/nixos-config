{ ... }:
{
  flake.nixosModules.fomonixSystem =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_zen;
      networking.hostName = "fomonix";
      time.timeZone = "America/Los_Angeles";
      i18n.defaultLocale = "en_US.UTF-8";

      users.users.feltfomo = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
          "input"
        ];
        # Password hash lives on /persist so it survives root wipes.
        # To set it up: sudo mkdir -p /persist/passwords
        #               echo 'YOUR_PASSWORD' | mkpasswd -m yescrypt | sudo tee /persist/passwords/feltfomo
        #               sudo chmod 600 /persist/passwords/feltfomo
        hashedPasswordFile = "/persist/passwords/feltfomo";
        shell = pkgs.fish;
      };

      programs.fish.enable = true;
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
      services.openssh.enable = true;
      nix.settings.accept-flake-config = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      programs.silentSDDM = {
        enable = true;
        theme = "rei";
      };

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        openssl
      ];

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operator"
        ];
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.11";
      documentation.man.enable = false;
    };
}
