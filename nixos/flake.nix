{
  description = "dotfiles (NixOS hosts)";

  inputs = {
    # Real NixOS release branch (as opposed to macos/flake.nix's Darwin-optimized branch)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # herdr isn't in nixpkgs proper yet; this flake wraps its official
    # prebuilt per-platform release binaries.
    herdr-nix.url = "github:herdrdev/herdr-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    herdr-nix,
    ...
  }: let
    user = import ../user.nix;

    mkHost = {
      system,
      hostModule,
      hardwareModule,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit user;};
        modules = [
          ./configuration.nix
          hostModule
          hardwareModule
          home-manager.nixosModules.home-manager
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
  in {
    # M5 MacBook Pro. Apple Silicon boot/kernel specifics (Asahi /
    # nixos-apple-silicon) are not wired up yet -- deferred until install time.
    nixosConfigurations.nixos = mkHost {
      system = "aarch64-linux";
      hostModule = ./hosts/nixos/configuration.nix;
      hardwareModule = ./hosts/nixos/hardware-configuration.nix;
    };

    # 2015 Intel MacBook Pro. Real, installed hardware/config -- see
    # hosts/nixos-i/.
    nixosConfigurations.nixos-i = mkHost {
      system = "x86_64-linux";
      hostModule = ./hosts/nixos-i/configuration.nix;
      hardwareModule = ./hosts/nixos-i/hardware-configuration.nix;
    };
  };
}
