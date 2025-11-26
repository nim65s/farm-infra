{
  inputs,
  ...
}:
let
  rosPkgs = import inputs.nixpkgs-ros {
    system = "x86_64-linux";
    overlays = [
      inputs.nix-ros-overlay.overlays.default
      # rosbridge want bson.BSON
      # but that is from pymongo which vendor bson…
      # let's globally override that
      (_final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: _python-prev: {
            bson = python-final.pymongo;
          })
        ];
      })
    ];
  };
  rosEnv =
    with rosPkgs.rosPackages.noetic;
    buildEnv {
      paths = [
        ros-core
        roslaunch
        rosbridge-server
        rospy-tutorials
        # those should not be necessary :/
        python3Packages.distutils
        python3Packages.pymongo
        python3Packages.pyopenssl
      ];
    };
  mkRobot =
    name: idx:
    let
      rosMasterPort = 11310 + idx;
      websocketPort = 9000 + idx;

      demoLaunch = ''
        <launch>
          <node pkg="rosbridge_server" type="rosbridge_websocket" name="rosbridge">
            <param name="port" value="${toString websocketPort}"/>
          </node>

          <node pkg="rospy_tutorials" type="talker" name="${name}_talker">
            <param name="robot_name" value="${name}"/>
          </node>
        </launch>
      '';
    in
    {
      environment.etc."${name}.launch".text = demoLaunch;
      systemd.services."${name}" = {
        description = "Manage ${name}";
        wantedBy = [ "multi-user.target" ];

        environment = {
          ROS_MASTER_URI = "http://localhost:${toString rosMasterPort}";
          ROS_HOSTNAME = "localhost";
          # HOME = "/srv/${name}";
        };
        serviceConfig = {
          ExecStart = "${rosEnv}/bin/roslaunch /etc/${name}.launch";
          Restart = "always";
          User = name;
          Group = name;
        };
      };

      users.groups."${name}" = { };
      users.users."${name}" = {
        isSystemUser = true;
        createHome = true;
        home = "/srv/${name}";
        homeMode = "0750";
        group = name;
        packages = [ rosEnv ];
      };
    };
in
{
  imports = [
    (mkRobot "salameche" 1)
    (mkRobot "carapuce" 2)
    (mkRobot "bulbizarre" 3)
  ];
}
