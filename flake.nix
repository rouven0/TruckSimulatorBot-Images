{
  description = "Image API for the Truck Simulator bot";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: {
        default = pkgs.${system}.python310Packages.callPackage ./default.nix { };
      });
      hydraJobs = forAllSystems (system: {
        default = self.packages.${system}.default;
      });
      nixosModules.default = import ./module.nix;

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = with pkgs.${system}; [
            self.packages."x86_64-linux".default
          ];
        };
      });
    };
}
