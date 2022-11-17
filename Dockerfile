FROM rocker/verse
MAINTAINER Zhongle Zhou <zhongle@unc.edu>
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('readxl')"
RUN R -e "install.packages('rmarkdown')"
RUN R -e "install_version("gutenbergr", version = "0.2.1", repos = "http://cran.us.r-project.org")"
