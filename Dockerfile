# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.4.1

# required
MAINTAINER Ben Marwick <bmarwick@uw.edu>

COPY . /huskydown

# go into the repo directory
RUN . /etc/environment \

  # Install linux depedendencies here
  # need this because rocker/verse doesn't have xelatex
  && sudo apt-get update \
  && sudo apt-get install texlive-xetex -y \
  && sudo apt-get install fonts-ebgaramond -y \
  && wget https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip \
  && unzip 1.017R.zip  \
  && sudo cp source-code-pro-1.017R/OTF/*.otf /usr/local/share/fonts/ \

  # build this compendium package
  && R -e "devtools::install('/huskydown', dep=TRUE)" \

 # make a PhD thesis from the template, remove pre-built PDF,
 # then render new thesis into a PDF, then check it could work:
  && R -e "rmarkdown::draft('index.Rmd', template = 'thesis', package = 'huskydown', create_dir = TRUE, edit = FALSE); setwd('index'); file.remove('_book/thesis.pdf'); bookdown::render_book('index.Rmd', huskydown::thesis_pdf(latex_engine = 'xelatex')); file.exists('_book/thesis.pdf')"
