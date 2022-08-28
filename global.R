#' global.R for GBMDeconvoluteR
#
# GBMDeconvoluteR is free software; you can redistribute it and/or 
# modify it under the terms of the GNU General Public License as published by 
# the Free SoftwareFoundation; either version 3 of the License, or (at your option) any later
# version.
#
# GBMDeconvoluteR is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <http://www.gnu.org/licenses/>.

# PACKAGES ----

library(shiny)
library(shinyBS)
library(shinycssloaders)
library(tidyverse)
library(markdown)
library(DT)
library(MCPcounter)
library(tinyscalop)
library(openxlsx)

# GLOABAL OPTIONS ----

# Disable graphical rendering by the Cairo package, if it is installed
options(shiny.usecairo = TRUE)

# Sets the maximum file upload size to 200Mb
options(shiny.maxRequestSize= 50*1024^2)

# DT options

options(
  
  DT.options = list(lengthMenu = list(c(50, 100, -1), 
                                      c('50','100','All')
                                      ), 
                     
                     buttons = list('copy', 
                                    list(extend = 'collection',
                                         buttons = c('csv', 'excel', 'pdf'),
                                         text = 'Download')
                                    ),
                    
                     serverSide = FALSE,
                     pagingType = "full",
                     dom = 'lfBrtip',
                     width = "100%",
                     height = "100%",
                     scrollX = TRUE,
                     scrollY = "475px",
                     scrollCollapse = TRUE, 
                     orderClasses = TRUE, 
                     autoWidth = FALSE,
                     search = list(regex = TRUE)
                    )
)




# LOAD DATA ----

# Function which reads in multiple datasets at once
load_datasets <- function(x){

  tryCatch(                       # Applying tryCatch
    
    expr = {                      # Specifying expression
      
      assign(x = tools::file_path_sans_ext(basename(x)),
             value = readRDS(x),
             envir = .GlobalEnv) 
      
      
      message(
        
        crayon::green("Loaded", tools::file_path_sans_ext(basename(x))),
        
        appendLF = TRUE
        
        )
      
    },
    
    error = function(e){          # Specifying error message
      
      message(
        
        crayon::red(tools::file_path_sans_ext(basename(x)), 
                    "Could Not Be Loaded!"),
        
        appendLF = TRUE
        
        )
    },
    
    warning = function(w){        # Specifying warning message
      message("There was a warning message.")
    }
  )
  
}

# load_datasets usage
# plyr::l_ply(indata, load_datasets)

gene_markers <- list()

gene_markers$neftel_sigs <- readRDS("data/neftel_sigs.rds")

gene_markers$immune <- readRDS("data/GBM_Immune_markers.rds")

gene_markers$tumor_intrinsic <- readRDS("data/GBM_tumor_intrinsic_genes.rds")

plot_cols <- readRDS("data/plot_colors.rds")


# PANEL DIVS ----

# Generates the panels found on the home and about tabs

panel_div <-function(class_type, panel_title, content) {
  HTML(paste0("<div class='panel panel-", class_type,
              "'> <div class='panel-heading'><h3 class='panel-title'>", panel_title,
              "</h3></div><div class='panel-body'>", content,  "</div></div>", sep=""))
}

# END ----
