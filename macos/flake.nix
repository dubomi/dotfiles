{
  description = "dotfiles";

  inputs = {
    # Pin everything to stable 26.05 version

    # Where to download package definitions from?
    # nixpkgs-26.05-darwin branch branch is built specifically for MacOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    # Bring in nix-darwin framework to manage MacOS system settings declaratively
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    # tell nix-darwin to use same instance of nixpkgs define above rather than pulling down it's own copies
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager to mange home directory
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # herdr isn't in nixpkgs proper yet; this flake wraps its official
    # prebuilt per-platform release binaries.
    herdr-nix.url = "github:herdrdev/herdr-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nix-homebrew,
    herdr-nix,
  }: let
    user = import ../user.nix;
  in {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit user;};
      modules = [
        ./darwin.nix
        ./homebrew.nix
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit user herdr-nix;};
          home-manager.users.${user} = {
            imports = [../home.nix ./home.nix];
          };
        }
      ];
    };
  };
}
