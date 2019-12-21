ifneq (,$(findstring B,$(MAKEFLAGS)))
latexmk_flags = -gg
endif

latexmk_flags += -cd -pdf


all: bin/aal docs/aal.pdf


bin/aal: src/aal.nw
	@ mkdir -p $(@D)
	@ notangle $< | cpif $@
	@ chmod +x $@


docs/aal.pdf: export TZ='America/Chicago'a
docs/aal.pdf: src/aal.tex src/preamble.tex
	@ mkdir -p $(@D)
	@ latexmk $(latexmk_flags) -outdir=../$(@D) $<


.INTERMEDIATE: src/aal.tex
src/aal.tex: src/aal.nw
	@ noweave -n -delay -index $< | cpif $@
