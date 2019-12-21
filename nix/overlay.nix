self: super: rec {

  noweb = super.noweb.override {
    icon-lang = super.icon-lang.override {
      withGraphics = false;
    };
  };

  xelatex = super.texlive.combine {
    inherit noweb;
    inherit (super.texlive) scheme-small
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

}
