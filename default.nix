{ buildPythonPackage, python311Packages, python, ... }:

buildPythonPackage {
  name = "trucksimulatorbot-images";
  src = ./app;

  propagatedBuildInputs = with python311Packages; [
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
