# Makefile

#SHELL=/bin/bash -O globstar

# Latex auxiliary files (note: aux is not present due to cross-reference)
CLEANEXT=*.fls *.idx *.ind *.ilg *.lof *.lot *.toc *.out *.log *.bcf *.blg *.bbl *-blx.bib *.run.xml *.thm *.synctex.gz *.fdb_latexmk

PDFIMG = $(patsubst %.svg,%.pdf, $(wildcard images/*/*.svg))
PDFDOC = principes/amhe_principes.pdf recueil/amhe_recueil.pdf recueil/amhe_ateliers.pdf

# convert svg to pdf
%.pdf: %.svg
	@inkscape -D -A $@ $<
	@sed -i "\/Group <</,+5d" $@

%.pdf %.aux: %.tex $(PDFIMG)
	latexmk -outdir=$(@D) -pdf $<
	rm -f $(@D)/$(CLEANEXT)

.PHONY: clean cleandoc cleanall cleanbuild images build recueil principes ateliers

build: $(PDFDOC)
	cp $(PDFDOC) .

cleanbuild: cleandoc $(PDFDOC)
	cp $(PDFDOC) .

clean:
	#latexmk -c
	rm -f $(addprefix recueil/, $(CLEANEXT) *.aux)
	rm -f $(addprefix principes/, $(CLEANEXT) *.aux)

cleandoc:
	rm -f $(PDFDOC)

cleanall: clean cleandoc
	rm -f $(PDFIMG)

images: $(PDFIMG)

principes: principes/amhe_principes.pdf
recueil: recueil/amhe_recueil.pdf
ateliers: recueil/amhe_ateliers.pdf

recueil/amhe_ateliers.pdf: recueil/amhe_recueil.aux

#@for file in **/*.svg ; do \
#	inkscape -D -A "$${file%.*}.pdf" "$$file" ;
#done

