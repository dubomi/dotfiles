# macOS-specific home-manager overlay. Imported alongside the shared ../home.nix
# in macos/flake.nix. Holds only the values that differ from Linux/NixOS:
# home.homeDirectory, and the darwin-specific paths for tools whose config
# location isn't the same across platforms (lazygit, VS Code).
{
  config,
  user,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in {
  home.homeDirectory = "/Users/${user}";

  # lazygit follows XDG_CONFIG_HOME on Linux, but on macOS its config dir is
  # hardcoded by Go's os.UserConfigDir() to ~/Library/Application Support and
  # never checks XDG_CONFIG_HOME.
  home.file."Library/Application Support/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/lazygit/config.yml";
  home.file."Library/Application Support/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/code/settings.json";
}
