# Final Project Skeleton

## Introduction

Project Gutenberg (PG) is a volunteer effort to digitize and archive cultural works, as well as to "encourage the creation and distribution of eBooks." It was founded in 1971 by American writer Michael S. Hart and is the oldest digital library. Most of the items in its collection are the full texts of books or individual stories in the public domain. All files can be accessed for free under an open format layout, available on almost any computer. As of 3 October 2015, Project Gutenberg had reached 50,000 items in its collection of free eBooks.

The releases are available in plain text as well as other formats, such as HTML, PDF, EPUB, MOBI, and Plucker wherever possible. Most releases are in the English language, but many non-English works are also available. There are multiple affiliated projects that provide additional content, including region- and language-specific works. Project Gutenberg is closely affiliated with Distributed Proofreaders, an Internet-based community for proofreading scanned texts.

In this project, I used the gutenbergr package in R to download and process public domain works from the Project Gutenberg collection and tried to answer the following questions:

1. How is the word usage different among different authors?
2. Is it possible to train a model that can predict the author of a work based on its word frequencies?
3. If the answer to question 2 is "yes," what method should we use to achieve a better performance?

## Usage

You can build the container by entering:
```
docker build . -t final_project
```
This Docker container is based on rocker/verse. To run rstudio server:
```
docker run -e PASSWORD=somepassword --rm -p 8787:8787 -v $(pwd):/home/rstudio/project -it final_project
```
Then, you can visit [http://localhost:8787](http://localhost:8787/) via a browser with username "rstudio and password "somepassword" to get the environment.

## Makefile

To make the final report, run:
```
make final.pdf
```
