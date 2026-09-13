{
  user,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # Stock NixOS doesn't enable these by default. This makes the setting
  # permanent from the second switch onward; the very first switch on a fresh
  # install still needs --extra-experimental-features on the CLI (see init.sh)
  # since this config isn't active yet at that point.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = ["wheel" "networkmanager"];
  };

  networking.networkmanager.enable = true;

  # GRUB (not systemd-boot) configured for Apple's locked/quirky NVRAM --
  # verified working on the 2015 Intel MacBook Pro. Apple Silicon (M5) will
  # need a completely different boot path (Asahi / nixos-apple-silicon),
  # still deferred -- see hosts/nixos/hardware-configuration.nix.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true; # sets the fallback path Apple's firmware looks for
  };
  boot.loader.efi = {
    canTouchEfiVariables = false; # prevents crashes on Apple's locked NVRAM
    efiSysMountPoint = "/boot";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.gdm.autoSuspend = false; # prevents sleep at the terminal
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [vim wget git google-chrome];

  time.timeZone = "America/Los_Angeles"; # TODO: confirm
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "26.05";
}
