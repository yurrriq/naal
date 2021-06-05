{

  description = "Non-interactive AWS Azure Login";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;
      pkgs = import inputs.nixpkgs {
        overlays = [
          self.overlays.noweb
        ];
        system = "x86_64-linux";
      };
    in
    {
      overlays = {
        naal = final: prev: {
          inherit (self.packages.x86_64-linux) naal;
        };
        noweb = final: prev: rec {
          noweb = prev.noweb.override {
            icon-lang = prev.icon-lang.override {
              withGraphics = false;
            };
          };
          xelatex = prev.texlive.combine {
            inherit noweb;
            inherit (prev.texlive) scheme-small
              catchfile
              datetime
              fmtcount
              framed
              fvextra
              hardwrap
              ifplatform
              latexmk
              mfirstuc
              minted
              substr
              titlesec
              tufte-latex
              xetex
              xindy
              xfor
              xstring
              ;
          };
        };
      };

      devShell.x86_64-linux = pkgs.mkShell {
        inherit (self.defaultPackage.x86_64-linux) FONTCONFIG_FILE;
        buildInputs = with pkgs;[
          # TODO: gitAndTools.pre-commit
          nixpkgs-fmt
        ] ++
        self.defaultPackage.x86_64-linux.nativeBuildInputs ++
        self.defaultPackage.x86_64-linux.buildInputs;
      };

      packages.x86_64-linux = {
        naal = with pkgs; stdenv.mkDerivation rec {
          pname = "naal";
          version = builtins.readFile ./VERSION;
          src = nix-gitignore.gitignoreSource [ ".git/" "bin" "docs" ] ./.;

          FONTCONFIG_FILE = makeFontsConf {
            fontDirectories = [ iosevka ];
          };

          nativeBuildInputs = [
            noweb
            python3Packages.pygments
            which
            xelatex
          ];

          buildInputs = [
            expect
            makeWrapper
            nodePackages.aws-azure-login
            (pass.withExtensions (exts: [ exts.pass-otp ]))
          ];

          outputs = [ "out" "doc" ];

          installPhase =
            let
              binPath = lib.makeBinPath [
                nodePackages.aws-azure-login
                (pass.withExtensions (exts: [ exts.pass-otp ]))
              ];
            in
            ''
              install -dm755 "$out/bin"
              install -m755 bin/naal "$_"
              wrapProgram "$out"/bin/naal --prefix PATH ${binPath}

              install -dm755 "$doc"
              install -m444 src/_config.yml src/index.md docs/naal.pdf "$_"
            '';

          meta = with lib; {
            description = "Non-interactive AWS Azure Login";
            homepage = "https://github.com/yurrriq/naal";
            license = licenses.mit;
            maintainers = with maintainers; [ yurrriq ];
            platforms = platforms.linux;
          };
        };
      };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.naal;
    };
}
