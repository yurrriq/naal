{ pkgs ? import ./nix {} }:


pkgs.mkShell {

  FONTCONFIG_FILE = pkgs.makeFontsConf {
    fontDirectories = [ pkgs.iosevka ];
  };

  buildInputs = with pkgs; [
    noweb
    python36Packages.pygments
    which
    xelatex-noweb
  ];

}
