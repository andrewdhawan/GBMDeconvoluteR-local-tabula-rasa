# This script contains the server logic for the GBMDeconvoluteR Shiny web application. 
# You can run the application by clicking 'Run App' above.

options(shiny.maxRequestSize=200*1024^2)

library(shiny)
library(tidyverse)
library(MCPcounter)
library(tinyscalop)
library(openxlsx)
# library(rsconnect)

# Define server logic
shinyServer(function(input, output, session) {
  
  # Reactivity required to display the Run button after file upload
  output$finishedUploading <- reactive({

    if (is.null(input$upload_file)) 0 else 1

    })

  outputOptions(output, 'finishedUploading', suspendWhenHidden=FALSE)
  
  
  user_data <- reactiveValues()
  

  # Data Upload reactivity
  data_upload <- eventReactive(input$upload_file, {

    # inFile <- input$upload_file

    if(tools::file_ext(input$upload_file$name) %in% "xlsx"){

      user_data$upData <- openxlsx::read.xlsx(input$upload_file$datapath,
                                    colNames = TRUE)

      }else if(tools::file_ext(input$upload_file$name) %in% "csv"){

        user_data$upData <- readr::read_csv(file = input$upload_file$datapath,
                                  col_types = cols())

        }else if(tools::file_ext(input$upload_file$name) %in% "tsv"){

          user_data$upData <- readr::read_tsv(file = input$upload_file$datapath,
                                    col_types = cols())

          }
  })
  

  # Reactive function to generate the Deconvolution markers
  deconv_markers_call <- eventReactive(input$deconvolute_button, valueExpr = {
    
    # Put the uploaded data into Log2 space
    exprs_matrix <- user_data$upData %>%
      
      tibble::column_to_rownames(colnames(user_data$upData)[[1]]) %>%
      
      as.matrix() %>%
      
      tinyscalop::exprs_levels(m = ., bulk = TRUE, log_scale = TRUE)
    
    
    # Filter out any genes which are zero across all samples
    exprs_matrix <- exprs_matrix[Matrix::rowSums(exprs_matrix) != 0,]                            
    
    
    # Refine Neftel markers
    set.seed(1234)
    
    gene_markers$neoplastic <- 
      tinyscalop::filter_signatures(m = exprs_matrix,
                                    sigs = gene_markers$neftel_sigs$four_sigs,
                                    filter.threshold = 0.4)
    
    
    gene_markers$neoplastic <- data.frame(
      
      "marker" = unlist(gene_markers$neoplastic, use.names = FALSE),
      
      "population" = rep(names(gene_markers$neoplastic), 
                         lengths(gene_markers$neoplastic))
    )
    
    
    # Tumour intrinsic neoplastic marker genes
    gene_markers$TI_neoplastic <- 
      gene_markers$neoplastic[gene_markers$neoplastic$marker %in% gene_markers$tumor_intrinsic,]
    
    
   # Clean up and combine refined markers
    
    if(input$tumour_intrinsic == "Yes"){
      
      user_data$deconv_markers <- gene_markers$TI_neoplastic %>% 
        
        tidyr::drop_na() %>%
        
        rename("HUGO symbols" = marker,
               "Cell population" = population) %>%
        
        rbind(gene_markers$immune)
      
    }else{
      
      user_data$deconv_markers <- gene_markers$neoplastic %>% 
      
      tidyr::drop_na() %>%
      
      rename("HUGO symbols" = marker,
             "Cell population" = population) %>%
      
      rbind(gene_markers$immune)
  
    }
    
  })
  
  
  # Deconvolution
  scores  <-  reactive({ 
    tinyscalop::MCPCounter_score(x = user_data$upData, 
                                 gene_pops = user_data$deconv_markers, 
                                 out_digits = 2)}
    
    )

  
  # Render the uploaded table
  output$uploaded_data <- DT::renderDataTable({
    
    validate(
      need(!is.null(input$upload_file),"Please Upload an Expression Data File")
    )
    
    datatable(data_upload(), 
              rownames = FALSE, 
              options = list(scrollX = TRUE, 
                             scrollY = 600,
                             scrollCollapse = TRUE, 
                             orderClasses = TRUE, 
                             autoWidth = FALSE,
                             search = list(regex = TRUE)
              )
    )
  }, server = TRUE)
  
  
  # Render the Deconvolution scores
  output$deconv_scores <- DT::renderDataTable({
    
    validate(
      need(!is.null(input$upload_file),"Please Upload a Dataset and run deconvolution to retrive scores"),
      need(!is.null(input$deconvolute_button),'Please press "Run Deconvolute"')
    )
    datatable(scores(),
              rownames = FALSE, 
              extensions = c("FixedColumns", 'Buttons'),
              options = list(scrollX = TRUE, 
                             scrollY = 600,
                             scrollCollapse = TRUE, 
                             orderClasses = TRUE, 
                             autoWidth = FALSE,
                             search = list(regex = TRUE)
              )
    )
  },server = FALSE)
  
  
  # Render the Deconvolution markers
  output$deconv_markers <- DT::renderDataTable({
    validate(
      need(!is.null(input$upload_file),"Please Upload a Dataset and run deconvolution to retrive scores"),
        need(!is.null(input$deconvolute_button),'Please press "Run Deconvolute"')
    )
    datatable(deconv_markers_call(),
              rownames = FALSE, 
              extensions = c("FixedColumns", 'Buttons'),
              options = list(scrollX = TRUE, 
                             scrollY = 600,
                             scrollCollapse = TRUE, 
                             orderClasses = TRUE, 
                             autoWidth = FALSE,
                             search = list(regex = TRUE)
              )
    )
  },server = FALSE)
  
  
  
})
