{ pkgs ? import ./nix {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "naal";
  version = builtins.readFile ./VERSION;
  src = pkgs.nix-gitignore.gitignoreSource [".git/" "bin" "docs" ] ./.;

  FONTCONFIG_FILE = with pkgs; makeFontsConf {
    fontDirectories = [ iosevka ];
  };

  nativeBuildInputs = with pkgs; [
    noweb
    python3Packages.pygments
    which
    xelatex
  ];

  buildInputs = with pkgs; [
    expect
    nodePackages.aws-azure-login
    (pass.withExtensions (exts: [ exts.pass-otp ]))
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with pkgs.stdenv.lib; {
    description = "Non-interactive AWS Azure Login";
    homepage = https://github.com/yurrriq/naal;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.linux;
  };
}
