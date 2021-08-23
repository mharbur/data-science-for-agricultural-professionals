FROM rocker/geospatial:4.0.4
MAINTAINER Marin L Harbur <mharbur@landolakes.com>


RUN Rscript -e "install.packages(c('rmarkdown','knitr', 'shiny','shinyWidgets'), repos = 'http://cran.rstudio.com/')"
RUN Rscript -e "install.packages(c('sf', 'tidyr'), repos = 'http://cran.rstudio.com/')"
RUN Rscript -e "install.packages(c('dplyr', 'ggplot2'), repos = 'http://cran.rstudio.com/')"
RUN Rscript -e "install.packages(c('prettydoc'), repos = 'http://cran.rstudio.com/')"


#copy the current folder into the path of the app
COPY . /usr/local/src/app
#set working directory to the app
WORKDIR /usr/local/src/app

#set the unix commands to run the app
CMD ["Rscript","app_run.R"]

EXPOSE 8080
