.PHONY: clean


clean:
	rm -rf results
	rm -rf .created-dirs
	rm -f df.csv
	rm -f final.pdf

.created-dirs:
	mkdir -p results
	touch .created-dirs

#explore the dataset
df.csv\
 results/language.pdf\
 results/authors.pdf\
 results/subjects.pdf\
 results/work_author.pdf\
 results/MarkTwain.pdf\
 results/Shakespeare.pdf\
 results/Dickens.pdf:\
 .created-dirs script/data_exploration.R
	Rscript script/data_exploration.R

#dimensino reduction
results/PCA.pdf results/tSNE.pdf: .created-dirs script/dimension_reduction.R df.csv
	Rscript script/dimension_reduction.R

#classification
results/PCA_variance.pdf\
 results/accuracy_gbm.pdf\
 results/Influence.pdf\
 results/accuracy_svm.pdf\
 results/accuracy_conparison.pdf:\
 .created-dirs script/classification.R df.csv
	Rscript script/classification.R

# Build the final report for the project
final.pdf:\
  final.Rmd\
  results/language.pdf\
  results/authors.pdf\
  results/subjects.pdf\
  results/work_author.pdf\
  results/MarkTwain.pdf\
  results/Shakespeare.pdf\
  results/Dickens.pdf\
  results/PCA.pdf\
  results/tSNE.pdf\
  results/PCA_variance.pdf\
  results/accuracy_gbm.pdf\
  results/Influence.pdf\
  results/accuracy_svm.pdf\
  results/accuracy_conparison.pdf
	Rscript -e "rmarkdown::render(\"final.Rmd\", output_format=\"pdf_document\")"

