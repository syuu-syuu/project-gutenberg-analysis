FROM rocker/verse
MAINTAINER Zhongle Zhou <zhongle@unc.edu>
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('tidytext')"
RUN R -e "install.packages('ggpubr')"
RUN R -e "install.packages('wordcloud')"
RUN R -e "install.packages('Rtsne')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('e1071')"
RUN R -e "install.packages('readxl')"
RUN R -e "install.packages('rmarkdown')"
RUN R -e "devtools::install_version('gutenbergr', version = '0.2.1', repos = 'http://cran.us.r-project.org')"
