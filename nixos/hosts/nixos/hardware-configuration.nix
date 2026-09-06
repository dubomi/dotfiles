# PLACEHOLDER. Replace with the real output of:
#   sudo nixos-generate-config --show-hardware-config
# run on the M5 MacBook Pro after installing NixOS.
#
# Apple Silicon boot/kernel support (Asahi Linux / nixos-apple-silicon) is not
# wired up yet -- this host will not boot on real M5 hardware as-is.
{modulesPath, ...}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  nixpkgs.hostPlatform = "aarch64-linux";
}
