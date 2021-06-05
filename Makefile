ifneq (,$(findstring B,$(MAKEFLAGS)))
latexmk_flags = -gg
endif

latexmk_flags += -cd -shell-escape -xelatex


all: bin/naal docs/naal.pdf


.PHONY: build
build:
	@ nix build .#naal


.PHONY: doc
doc:
	@ nix build .#naal.doc


bin/naal: src/naal.nw
	@ mkdir -p $(@D)
	@ notangle $< | cpif $@
	@ chmod +x $@


docs/naal.pdf: export TZ='America/Chicago'
docs/naal.pdf: src/naal.tex src/preamble.tex
	@ mkdir -p $(@D)
	@ latexmk $(latexmk_flags) -outdir=../$(@D) $<


.INTERMEDIATE: src/naal.tex
src/naal.tex: src/naal.nw
	@ noweave -n -delay -index $< | cpif $@
