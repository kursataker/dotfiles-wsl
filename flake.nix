{
  description = "Ramiro's WSL Ubuntu home config - the Linux half of the dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Add tuios here
    tuios.url = "github:Gaurav-Gosain/tuios";
  };

  outputs = { self, nixpkgs, home-manager, tuios, ... }@inputs: {
    homeConfigurations."aker" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;  # claude-code has a proprietary license
        extraSpecialArgs = { inherit inputs; }; # Pass inputs so home.nix can see them
      };
      modules = [ ./home.nix ];
    };
  };
}
