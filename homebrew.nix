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
    brews = [
      "herdr"
    ];
    casks = [
      "wezterm"
      "claude"
      "claude-code"
      "opensuperwhisper"
    ];
  };
}
