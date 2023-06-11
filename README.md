## Introduction

Project Gutenberg (PG) is a pioneering venture in the realm of digital libraries, amassing a wealth of cultural and literary works since its inception in 1971. Recognized as the oldest digital library, PG is known for offering a wide array of public domain books and stories in an easily accessible open format.

In this project, we used the gutenbergr package in R to download and process public domain works from the Project Gutenberg collection and tried to answer the following questions:

1. How is the word usage different among different authors?
2. Is it possible to train a model that can predict the author of a work based on its word frequencies?
3. If the answer to question 2 is "yes," what method should we use to achieve a better performance?

Our investigation applied multifaceted approaches, with key activities including:
- Implementing dimensionality reduction techniques, specifically Principal Component Analysis (PCA) and t-Distributed Stochastic Neighbor Embedding (t-SNE), to graphically represent the disparity in word usage amongst different authors.
- Evaluating the efficacy of Gradient Boosting Machines (GBM) and Support Vector Machines (SVM) for predicting authorship by scrutinizing the word frequency distributions in the respective author's works.
- Optimizing machine learning models to enhance literary analysis and authorship prediction accuracy.


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


To make the final report, run:
```
make final.pdf
```
