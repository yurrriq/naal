ifneq (,$(findstring B,$(MAKEFLAGS)))
latexmk_flags = -gg
endif

latexmk_flags += -cd -pdf


all: aal.sh aal.pdf


aal.pdf: export TZ='America/Chicago'
aal.pdf: aal.tex preamble.tex
	@ latexmk $(latexmk_flags) $<


.INTERMEDIATE: aal.tex
aal.tex: aal.nw
	@ noweave -n -delay -index $< | cpif $@


aal.sh: aal.nw
	@ notangle $< | shfmt -i 4 | cpif $@
	@ chmod +x $@
