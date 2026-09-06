{...}: {
  networking.hostName = "nixos";

  # Apple Silicon boot (Asahi / nixos-apple-silicon) is still deferred -- see
  # hardware-configuration.nix in this same folder.
}
