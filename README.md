# Final Project Skeleton

## Introduction to Project Gutenberg

Project Gutenberg was the first provider of free electronic books, or eBooks. Michael Hart, founder of Project Gutenberg, invented eBooks in 1971 and his memory continues to inspire the creation of eBooks and related content today.

## Usage

You can build the container:
```
docker build . -t final_project
```
This Docker container is based on rocker/verse. To run rstudio server:
```
docker run -e PASSWORD=somepassword --rm -p 8787:8787\
	-v $(pwd):/home/rstudio/project rocker/verse
```
You then visit [http://localhost:8787](http://localhost:8787/) via a browser on your machine with username rstudio and password "somepassword" to access the machine and development environment.

## Makefile

To make the final report, you can run:
```
make final.pdf
```
