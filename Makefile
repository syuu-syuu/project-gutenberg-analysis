.PHONY: clean


clean:
	rm -rf results
	rm -rf .created-dirs
	rm -f works.csv
	rm -f final.pdf

.created-dirs:
	mkdir -p results
	touch .created-dirs

#explore the dataset
works.csv results/ActiveDecade.png: .created-dirs script/data_exploration.R \
	source/Authors_Metadata.xlsx
	Rscript script/data_exploration.R

# Build the final report for the project
final.pdf:\
  final.Rmd\
  results/ActiveDecade.png
	Rscript -e "rmarkdown::render(\"final.Rmd\", output_format=\"pdf_document\")"
