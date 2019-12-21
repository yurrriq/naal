{
  pkgs ? import ./nix {},
  src ? pkgs.nix-gitignore.gitignoreRecursiveSource [".git/" "bin" "docs" ] ./.
}:

pkgs.stdenv.mkDerivation rec {
  pname = "naal";
  version = builtins.readFile ./VERSION;
  inherit src;

  FONTCONFIG_FILE = pkgs.makeFontsConf {
    fontDirectories = [ pkgs.iosevka ];
  };

  nativeBuildInputs = with pkgs; [
    noweb
    python36Packages.pygments
    which
    xelatex
  ];

  buildInputs = with pkgs; [
    expect
    nodePackages.aws-azure-login
    (pass.withExtensions (exts: [ exts.pass-otp] ))
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
}
