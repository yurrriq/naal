{ pkgs ? import ./nix {} }:

let
  pkg = import ./. { inherit pkgs; };
in

pkgs.mkShell {
  inherit (pkg) FONTCONFIG_FILE;
  buildInputs = with pkg; nativeBuildInputs ++ buildInputs;
}
