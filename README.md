# Final Project Skeleton

## Introduction to Project Gutenberg

Project Gutenberg was the first provider of free electronic books, or eBooks. Michael Hart, founder of Project Gutenberg, invented eBooks in 1971 and his memory continues to inspire the creation of eBooks and related content today.

## Dataset

The Gutenberg dataset represents a corpus of over 15,000 book texts, their authors and titles. The data has been scraped from the Project Gutenberg website using a custom script to parse all bookshelves. 

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
