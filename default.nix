{ buildPythonPackage, python310Packages, python, ... }:

buildPythonPackage {
  name = "trucksimulatorbot-images";
  src = ./app;

  propagatedBuildInputs = with python310Packages; [
    flask
    gunicorn
    pillow
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/${python.sitePackages}
    cp -r . $out/${python.sitePackages}/trucksimulatorbot-images
    runHook postInstall '';

  shellHook = "export FLASK_APP=trucksimulatorbot-images";

  format = "other";
}
