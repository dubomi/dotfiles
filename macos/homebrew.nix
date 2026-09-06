{user, ...}: {
  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = ["--force"];
    casks = [
      "claude"
      "opensuperwhisper"
    ];
  };
}
