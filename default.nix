{ pkgs ? import ./nix {} }:

{

  naal = import ./release.nix { inherit pkgs; };

}
