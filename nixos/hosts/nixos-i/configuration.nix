{ config, pkgs, ... }: let
  aic8800 = config.boot.kernelPackages.callPackage ../../pkgs/aic8800.nix {};
in {
  networking.hostName = "nixos-i";

  # BrosTrend AX300 USB WiFi (AIC8800FC chipset).
  # Same derivation added to both lists: extraModulePackages picks up the .ko
  # files; hardware.firmware picks up lib/firmware/aic8800/ from the same path.
  boot.extraModulePackages = [ aic8800 ];
  hardware.firmware = [ aic8800 ];

  # The adapter ships as a "ZeroCD" device (VID a69c / PID 5721) that presents
  # as a USB mass-storage disk until ejected, at which point it re-enumerates
  # as a WiFi adapter (VID 368b / PID 88df).
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5721", RUN+="${pkgs.util-linux}/bin/eject /dev/%k"
  '';

  # Disable Broadcom built-in WiFi
  boot.blacklistedKernelModules = [ "b43" "bcma" "ssb" "wl" ];
}
