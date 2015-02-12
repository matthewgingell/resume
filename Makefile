all: output/resume.tex output/resume.pdf

output/resume.tex: toLatex.rb gingell.yaml
	./toLatex.rb > output/resume.tex

output/resume.pdf: output/resume.tex theme.tex
	xelatex -output-directory output output/resume.tex

clean:
	rm -f output/*
