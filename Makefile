ifneq (,$(findstring B,$(MAKEFLAGS)))
latexmk_flags = -gg
endif

latexmk_flags += -cd -shell-escape -xelatex


all: bin/naal docs/naal.pdf


.PHONY: build
build:
	@ nix build -f . naal


.PHONY: doc
doc:
	@ nix build -f . naal.doc


.PHONY: update
update: package ?= nixpkgs
update: sources := nix/sources.json
update: rev = $(shell jq -r '.["${package}"].rev[:8]' ${sources})
update: COMMIT_MSG_FILE = .git/COMMIT_EDITMSG
update:
	@ niv update ${package}
	@ git add ${sources}
	@ jq '"${package}: ${rev} -> \(.["${package}"].rev[:8])"' \
	${sources} | xargs git commit -m


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
