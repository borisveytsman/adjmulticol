#
# Makefile for adjmulticol package
#
# This file is in public domain
#
# $Id$
#

PACKAGE=adjmulticol
SAMPLES = sample.tex

all:  $(PACKAGE).pdf ${SAMPLES:%.tex=%.pdf} 


%.pdf:  %.dtx   $(PACKAGE).sty
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done


%.pdf:  %.tex   $(PACKAGE).sty
	pdflatex $<
	- bibtex $*
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done


%.sty:   %.ins %.dtx  
	pdflatex $<



.PRECIOUS:  $(PACKAGE).cfg $(PACKAGE).sty


clean:
	$(RM)  $(PACKAGE).sty $(PACKAGE).log $(PACKAGE).aux \
	$(PACKAGE).cfg $(PACKAGE).glo $(PACKAGE).idx $(PACKAGE).toc \
	$(PACKAGE).ilg $(PACKAGE).ind $(PACKAGE).out $(PACKAGE).lof \
	$(PACKAGE).lot $(PACKAGE).bbl $(PACKAGE).blg $(PACKAGE).gls \
	$(PACKAGE).dvi $(PACKAGE).ps

veryclean: clean
	$(RM) $(PACKAGE).pdf

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	tar -czvf $(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude CVS .
