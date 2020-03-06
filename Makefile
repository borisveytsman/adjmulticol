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
	$(RM)  $(PACKAGE).sty *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.tgz *.zip

veryclean: clean
	$(RM) *.pdf

distclean: veryclean

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	COPYFILE_DISABLE=1 tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude '*.zip'  --exclude CVS --exclude '.git*' $(PACKAGE); mv ../$(PACKAGE).tgz .

zip:  all clean
	${MAKE} $(PACKAGE).sty
	$(RM) *.log
	zip -r  $(PACKAGE).zip * -x '*~' -x '*.tgz' -x '*.zip' -x "*.ins" -x CVS -x 'CVS/*'
