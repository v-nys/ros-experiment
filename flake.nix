{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs"; # IMPORTANT!!!
  };
  outputs =
    {
      self,
      nix-ros-overlay,
      nixpkgs,
    }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Example project";
          # see https://docs.ros.org/en/humble/Concepts/Intermediate/About-Domain-ID.html
          ROS_DOMAIN_ID = 50;
          packages = [
            pkgs.colcon
            # ... other non-ROS packages
            (
              with pkgs.rosPackages.humble;
              buildEnv {
                paths = [
                  ros-core
                  turtlesim
                  # ... other ROS packages
                ];
              }
            )
          ];
        };
      }
    );
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
