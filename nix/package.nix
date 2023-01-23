{
  pkgs,
  pythonPkgs ? pkgs.python310Packages,
  ...
}: let
  package = {
    buildPythonPackage,
    requests,
  }:
    buildPythonPackage {
      pname = "hypixel-tracker";
      version = "0.0.2";
      src = ../.;
      propagatedBuildInputs = [requests];
      doCheck = false;
      meta.description = "Tracks a player's current status on Hypixel and sends the result to a webhook.";
    };
in
  pythonPkgs.callPackage package {}
