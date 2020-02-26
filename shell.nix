{ pkgs ? import ./nix {} }:

let
  pkg = import ./release.nix { inherit pkgs; };
in

pkgs.mkShell {
  inherit (pkg) FONTCONFIG_FILE;
  buildInputs = (with pkg; nativeBuildInputs ++ buildInputs) ++ (
    with pkgs; [
      niv
    ]
  );
}
