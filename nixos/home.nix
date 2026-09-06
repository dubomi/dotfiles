# NixOS/Linux-specific home-manager overlay. Imported alongside the shared
# ../home.nix in nixos/flake.nix. Holds the values that differ from macOS:
# home.homeDirectory, and the Linux-specific paths for tools whose config
# location isn't the same across platforms (lazygit, VS Code). All packages
# are unified in shared ../home.nix now, including wezterm.
{
  config,
  user,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in {
  home.homeDirectory = "/home/${user}";

  home.file.".config/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/lazygit/config.yml";
  home.file.".config/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/code/settings.json";
}
