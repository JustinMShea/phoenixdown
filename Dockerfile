# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.4.1

# required
MAINTAINER Ben Marwick <bmarwick@uw.edu>

COPY . /huskydown

# go into the repo directory
RUN . /etc/environment \

  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  # && sudo apt-get update \
  # && sudo apt-get install libudunits2-dev -y \

  # build this compendium package
  && R -e "devtools::install('/huskydown', dep=TRUE)" \

 # make a PhD thesis from the template, remove pre-built PDF,
 # then render new thesis into a PDF, then check it could work:
  && R -e "rmarkdown::draft('index.Rmd', template = 'thesis', package = 'huskydown', create_dir = TRUE, edit = FALSE); setwd('index'); file.remove('_book/thesis.pdf'); bookdown::render_book('index.Rmd', huskydown::thesis_pdf(latex_engine = 'xelatex')); file.exists('_book/thesis.pdf')"
