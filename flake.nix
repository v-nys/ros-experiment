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
          # see https://docs.ros.org/en/kilted/Concepts/Intermediate/About-Domain-ID.html
          ROS_DOMAIN_ID = 50;
          packages = [
            pkgs.colcon
            # ... other non-ROS packages
            (
              with pkgs.rosPackages.kilted;
              buildEnv {
                paths = [
                  ros-core
                  turtlesim
                  # all rqt stuff from the overlay
                  rqt
                  rqt-action
                  rqt-bag
                  # rqt-bag-plugins
                  rqt-common-plugins
                  rqt-console
                  # rqt-controller-manager
                  # rqt-dotgraph
                  # rqt-gauges
                  rqt-graph
                  rqt-gui
                  # rqt-gui-cpp
                  # rqt-gui-py
                  rqt-image-overlay
                  rqt-image-overlay-layer
                  rqt-image-view
                  # rqt-joint-trajectory-controller
                  # rqt-mocap4r2-control
                  # rqt-moveit
                  rqt-msg
                  # rqt-play-motion-builder
                  # rqt-plot
                  rqt-publisher
                  rqt-py-common
                  # rqt-py-console
                  # rqt-reconfigure
                  # rqt-robot-dashboard
                  # rqt-robot-monitor
                  # rqt-robot-steering
                  # rqt-runtime-monitor
                  rqt-service-caller
                  rqt-shell
                  rqt-srv
                  rqt-tf-tree
                  rqt-topic
                  # all Webots integrations from the overlay
                  webots-ros2
                  # webots-ros2-control
                  # webots-ros2-core
                  # webots-ros2-crazyflie
                  # webots-ros2-driver
                  # webots-ros2-epuck
                  # webots-ros2-husarion
                  # webots-ros2-importer
                  # webots-ros2-mavic
                  # webots-ros2-msgs
                  # webots-ros2-tesla
                  # webots-ros2-tests
                  # webots-ros2-tiago
                  # webots-ros2-turtlebot
                  webots-ros2-universal-robot
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
