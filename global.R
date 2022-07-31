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
library(DT)
library(shinyBS)
library(tidyverse)
library(MCPcounter)
library(tinyscalop)
library(openxlsx)


options(shiny.usecairo = TRUE)

# DATA ----

# Reads in multiple datasets at once
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


# REMOVE NA COLUMNS  ----

.rmNA <- function (df) {
  df <- df[,colSums(is.na(df)) < nrow(df)]
}


# DATA TABLE ----

options(DT.options  = list(lengthMenu = list(c(20, 50, 100, -1), c('20','50','100','All')), 
                           serverSide = FALSE,
                           pagingType = "full",
                           dom = 'lfBrtip',
                           buttons = list('copy', 'print', list(
                             extend = 'collection',
                             buttons = c('csv', 'excel', 'pdf'),
                             text = 'Download'
                           ))
)
)

data_table <- function (df,rownames = FALSE, 
                        selection = 'none', 
                        filter = "none", 
                        options = list()) {DT::datatable(df, selection = selection, rownames = rownames, filter = filter, extensions = 'Buttons')
  
}

# PANEL DIVS ----

panel_div <-function(class_type, panel_title, content) {
  HTML(paste0("<div class='panel panel-", class_type,
              "'> <div class='panel-heading'><h3 class='panel-title'>", panel_title,
              "</h3></div><div class='panel-body'>", content,  "</div></div>", sep=""))
}


# BUSY ANIMATION ----

busy <- function (text = "") {
  div(class = "busy",
      img(src="gifs/Busy_running.gif", 
          width = "400px", height = "200px"),
      # hr(),
      # p(text)
  )
}

# HELP POPUP ----

#  Help popup (https://gist.github.com/jcheng5/5913297) 
##https://groups.google.com/forum/#!searchin/shiny-discuss/helpPopup/shiny-discuss/ZAkBsL5QwB4/vnmbT47uY7gJ

helpModal <- function(modal_title, link, help_file) {
  sprintf("<div class='modal fade' id='%s' tabindex='-1' role='dialog' aria-labelledby='%s_label' aria-hidden='true'>
          <div class='modal-dialog'>
          <div class='modal-content'>
          <div class='modal-header'>
          <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
          <h4 class='modal-title' id='%s_label'>%s</h4>
          </div>
          <div class='modal-body'>%s</div>
          </div>
          </div>
          </div>
          <i title='Help' class='fa fa-question-circle' data-toggle='modal' data-target='#%s'></i>",
          link, link, link, modal_title, help_file, link) %>%
    enc2utf8 %>% HTML
}

helpPopup <- function(content, title = NULL) {
  a(href = "#",
    class = "popover-link",
    `data-toggle` = "popover",
    `data-title` = title,
    `data-content` = content,
    `data-html` = "true",
    `data-trigger` = "hover",
    icon("question-circle")
  )
}


# END ----
