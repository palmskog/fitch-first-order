include Makefile.detect-coq-version

ifeq (,$(filter $(COQVERSION),8.6 8.7 trunk))
$(error "only compatible with Coq version 8.6 or later")
endif

COQPROJECT_EXISTS = $(wildcard _CoqProject)
ifeq "$(COQPROJECT_EXISTS)" ""
$(error "Run ./configure before running make")
endif

OTT = ott
PDFLATEX = pdflatex

OTTFILES = fitch_first_order.ott
VFILES = $(OTTFILES:.ott=.v)
TEXFILES = $(OTTFILES:.ott=.tex)
PDFFILES = $(OTTFILES:.ott=.pdf)

default: Makefile.coq
	$(MAKE) -f Makefile.coq

Makefile.coq: $(VFILES)
	coq_makefile -f _CoqProject -o Makefile.coq -install none

$(VFILES): %.v: %.ott
	$(OTT) -o $@ -coq_expand_list_types false $<

$(TEXFILES): %.tex: %.ott
	$(OTT) -o $@ $<

$(PDFFILES): $(TEXFILES)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	if [ -f Makefile.coq ]; then \
	  $(MAKE) -f Makefile.coq cleanall; fi
	rm -f Makefile.coq $(VFILES) *.aux *.log *.pdf

.PHONY: default clean
