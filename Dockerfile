# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.4.4

# required
MAINTAINER Ben Marwick <bmarwick@uw.edu>

COPY . /huskydown

# go into the repo directory
RUN . /etc/environment \

  # Install linux depedendencies here
  #  rocker/verse has xelatex 
  && sudo apt-get update \
  # install fonts
  && sudo apt-get install fonts-ebgaramond -y \
  && sudo git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/source-code-pro \
  && sudo fc-cache -f -v \
  && sudo apt-get install fonts-lato -y \

  # build this compendium package
  && R -e "devtools::install('/huskydown', dep=TRUE)" \

 # make a PhD thesis from the template, remove pre-built PDF,
 # then render new thesis into a PDF, then check it could work:
  && R -e "rmarkdown::draft('index.Rmd', template = 'thesis', package = 'huskydown', create_dir = TRUE, edit = FALSE)" \
  && R -e "if (file.exists('index/_book/thesis.pdf')) file.remove('index/_book/thesis.pdf')" \
  && R -e "setwd('index');  bookdown::render_book('index.Rmd', huskydown::thesis_pdf(latex_engine = 'xelatex')); setwd('..')"; \
  && R -e "file.exists('_book/thesis.pdf')"
