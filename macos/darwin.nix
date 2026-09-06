{user, ...}: {
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  # allow packages that are not free
  nixpkgs.config.allowUnfree = true;
  # aarch64-darwin for mas silicon, x86_64-darwin for Intel CPU
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = user;

  # set home directory for the user
  users.users.${user} = {
    home = "/Users/${user}";
  };

  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = null; #"Dark" | null
      KeyRepeat = 2; # fast key repeat
      InitialKeyRepeat = 15; # short delay before repeat
      _HIHideMenuBar = false; # keep the menu bar always visible (don't auto-hide)
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    dock.tilesize = 42; # dock icon size in pixels
    finder.FXPreferredViewStyle = "Nlsv"; # list view by default
    finder.CreateDesktop = false; # clean desktop
    finder.AppleShowAllFiles = true; # show hidden and system files
    trackpad.Clicking = false; # disable tap to click (physical click only)

    ".GlobalPreferences"."com.apple.mouse.scaling" = 3.0; # mouse tracking speed (0-3, 3 = fastest)

    CustomUserPreferences.NSGlobalDomain."com.apple.scrollwheel.scaling" = 1.7; # scroll speed
  };
}
