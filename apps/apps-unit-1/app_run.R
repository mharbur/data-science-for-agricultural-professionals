require(shiny) #loads shiny package
require(rmarkdown)
require(knitr)

rmarkdown::run("01-app-histogram.Rmd", shiny_args = list(port = 8080, host = '0.0.0.0')) #runs shiny app in port 8080 localhost