ifneq (,$(findstring B,$(MAKEFLAGS)))
latexmk_flags = -gg
endif

latexmk_flags += -cd -pdf


all: bin/aal aal.pdf


bin/aal: aal.nw
	@ notangle $< | cpif $@
	@ chmod +x $@


aal.pdf: export TZ='America/Chicago'
aal.pdf: aal.tex preamble.tex
	@ latexmk $(latexmk_flags) $<


.INTERMEDIATE: aal.tex
aal.tex: aal.nw
	@ noweave -n -delay -index $< | cpif $@
