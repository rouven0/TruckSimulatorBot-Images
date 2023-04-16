{ lib, buildPythonPackage, fetchPypi, python310Packages, python, ... }:

buildPythonPackage {
  name = "Purge";
  src = ./app;

  propagatedBuildInputs = with python310Packages; [
    flask
    gunicorn
    pillow
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/${python.sitePackages}
    cp -r . $out/${python.sitePackages}/purge
    runHook postInstall '';

  shellHook = "export FLASK_APP=trucksimulatorbot-images";

  format = "other";
}
