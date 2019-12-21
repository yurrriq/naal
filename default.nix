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

  meta = with pkgs.stdenv.lib; {
    description = "Non-interactive AWS Azure Login";
    homepage = https://github.com/yurrriq/naal;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.linux;
  };
}
