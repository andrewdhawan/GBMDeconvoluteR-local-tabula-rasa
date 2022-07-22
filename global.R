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


# DATASETS ----

# datasets <- list(
#   adult_datasets = c("CGGA","TCGA_GBM", "TCGA_LGG","TCGA_GBMLGG", "Rembrandt", "Gravendeel","Bao", "Kamoun","Ivy_GAP", "LeeY", "Oh","Phillips",
#                      "Gill", "Freije", "Murat","Gorovets", "POLA_Network", "Reifenberger", "Joo","Ducray", "Walsh", "Nutt", "Kwom", "Vital",
#                      "Grzmil", "Gleize", "Donson", "Li"),
#   pediatric_datasets = c("Cavalli", "Northcott_2012","Sturm_2016","Bergthold","Griesinger","Gump","Northcott_2011","Pomeroy",
#                          "Johnson","Robinson","Witt", "Kool_2014","Henriquez","Hoffman","Kool_2011","Lambert","Paugh", "deBont","Johann",
#                          "Zakrzewski","Sturm_2012","Buczkowicz","Mascelli","Schwartzentruber","Bender"),
#   no_surv_dataset = c("Bao","Reifenberger","Gill","Li", "Oh","Ivy_GAP", "Kwom","Walsh","Gleize",
#                       "Sturm_2016","Henriquez","Bergthold","Buczkowicz","Mascelli","Lambert","Griesinger",
#                       "Zakrzewski","Bender", "deBont","Gump","Johnson","Northcott_2012","Northcott_2011", "Kool_2011",
#                       "Johann","Robinson","Kool_2014"),
#   rnaseq_datasets = c("CGGA", "TCGA_LGG", "TCGA_GBMLGG", "Bao", "Ivy_GAP","Gill")
# )

# 
# indata  <- unlist(datasets[1:2],use.names = F)
# 
# indata <- list.files("data/datasets", pattern = paste0(indata, collapse = "|"), 
#                     full.names = T)


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

# plyr::l_ply(indata, load_datasets)



# OTHER VARS ----

gene_markers <- list()

gene_markers$neftel_sigs <- readRDS("data/neftel_sigs.rds")

gene_markers$immune <- readRDS("data/GBM_Immune_markers.rds")

gene_markers$tumor_intrinsic <- readRDS("data/GBM_tumor_intrinsic_genes.rds")


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
data_table <- function (df,rownames = FALSE, selection = 'none', filter = "none", options = list()) {
  DT::datatable(df, selection = selection, rownames = rownames, filter = filter, extensions = 'Buttons')
  
}


panel_div <-function(class_type, panel_title, content) {
  HTML(paste0("<div class='panel panel-", class_type,
              "'> <div class='panel-heading'><h3 class='panel-title'>", panel_title,
              "</h3></div><div class='panel-body'>", content,  "</div></div>", sep=""))
}


# BUSY ANIMATION ----

busy <- function (text = "") {
  div(class = "busy",
      p("Calculating, please wait"),
      img(src="Rotating_brain.gif"),
      hr(),
      p(text)
  )
}


# ALTER_FUN_LIST ----

alter_fun_list = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "#CCCCCC", col = NA))
  },
  HOMDEL = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "blue3", col = NA))
  },
  HETLOSS = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "cadetblue1", col = NA))
  },
  GAIN = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "pink", col = NA))
  },
  AMP = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "red", col = NA))
  },
  MUT = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h*0.33, gp = gpar(fill = "#008000", col = NA))
  }
)


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
