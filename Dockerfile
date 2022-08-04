# Install R version 3.5
FROM rocker/shiny:latest

# Install Ubuntu packages
RUN apt-get update && apt-get --no-install-recommends install -y \
    libssl-dev \
    libxml2-dev

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Copy configuration files into the Docker image
COPY ./renv.lock ./renv.lock

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::restore()'

COPY . /srv/shiny-server

USER shiny

EXPOSE 3838
