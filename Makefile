ifneq (,$(findstring B,$(MAKEFLAGS)))
latexmk_flags = -gg
endif

latexmk_flags += -cd -shell-escape -xelatex


all: bin/naal docs/naal.pdf


.PHONY: install
install: all
	@ install -dm755 "${PREFIX}/docs"
	@ install -m444 docs/naal.pdf "${PREFIX}/docs/"
	@ install -dm755 "${PREFIX}/bin"
	@ install -m755 bin/naal "${PREFIX}/bin"

bin/naal: src/naal.nw
	@ mkdir -p $(@D)
	@ notangle $< | cpif $@
	@ chmod +x $@


docs/naal.pdf: export TZ='America/Chicago'a
docs/naal.pdf: src/naal.tex src/preamble.tex
	@ mkdir -p $(@D)
	@ latexmk $(latexmk_flags) -outdir=../$(@D) $<


.INTERMEDIATE: src/naal.tex
src/naal.tex: src/naal.nw
	@ noweave -n -delay -index $< | cpif $@
