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
  
# DYNAMIC RUN BUTTON -----------------------------------------------------------
  
  # Render the uploaded table
  output$uploaded_data <- DT::renderDataTable({
    
    # input$upload_file will be NULL initially. After the user selects
    # and uploads a file, this data will be displayed in the uploaded data tab 
    
    validate(
      need(!is.null(input$upload_file),"Please upload a dataset to view")
    )
    
    
    datatable(uploaded_data(), 
              rownames = FALSE, 
              options = list(scrollX = TRUE, 
                             scrollY = 300,
                             # paging = FALSE,
                             pageLength = 20,
                             scrollCollapse = TRUE, 
                             orderClasses = TRUE, 
                             autoWidth = FALSE,
                             search = list(regex = TRUE)
              )
    )
  }, server = TRUE)
  
  
  # Reactivity required to display the Run button after upload
  output$finishedUploading <- reactive({
    
    if (is.null(input$upload_file)) 0 else 1
    
  })
  
  outputOptions(output, 'finishedUploading', suspendWhenHidden=FALSE)
  
  
  
# USER UPLOADED DATA -----------------------------------------------------------
  
  user_data <- reactiveValues()
  
  uploaded_data <- eventReactive(input$upload_file, {
    
    # Load in the user data ----
    
    if(tools::file_ext(input$upload_file$name) %in% "xlsx"){
      
      df <- openxlsx::read.xlsx(input$upload_file$datapath,
                                colNames = TRUE)
      
    }else if(tools::file_ext(input$upload_file$name) %in% "csv"){
      
      df <- readr::read_csv(input$upload_file$datapath,
                            col_types = cols())
      
    }else if(tools::file_ext(input$upload_file$name) %in% "tsv"){
      
      df <- readr::read_tsv(input$upload_file$datapath,
                            col_types = cols())
      
    }
    
    # Refine neoplastic signatures ----
    
    # Put the uploaded data into Log2 space
    exprs_matrix <- df %>%
      
      tibble::column_to_rownames(colnames(df)[[1]]) %>%
      
      as.matrix() %>%
      
      tinyscalop::exprs_levels(m = ., bulk = TRUE, log_scale = TRUE)
    
    
    # Filter out any genes which are zero across all samples
    exprs_matrix <- exprs_matrix[Matrix::rowSums(exprs_matrix) != 0,]                            
    
    
    # Refine Neftel markers
    set.seed(1234)
    
    refined_neoplastic <- 
      tinyscalop::filter_signatures(m = exprs_matrix,
                                    sigs = gene_markers$neftel_sigs$four_sigs,
                                    filter.threshold = 0.4)
    
    
    refined_neoplastic <- data.frame(
      
      "marker" = unlist(refined_neoplastic, use.names = FALSE),
      
      "population" = rep(names(refined_neoplastic), 
                         lengths(refined_neoplastic))
    )
    
    
    TI_refined_neoplastic <- 
      refined_neoplastic[refined_neoplastic$marker %in% gene_markers$tumor_intrinsic,]
    
    
    # Outputs ----
    
    user_data$exprs <- df
    
    user_data$refined_neoplastic <- refined_neoplastic
    
    user_data$TI_refined_neoplastic <- TI_refined_neoplastic
    
    return(df)
    
  }) 
  
#  DECONVOLUTION MARKERS -------------------------------------------------------
  
  get_markers <- reactive({ 
    
    if(input$tumour_intrinsic){
      
      deconv_markers <-  user_data$TI_refined_neoplastic %>% 
        
        tidyr::drop_na() %>%
        
        rename("HUGO symbols" = marker,
               "Cell population" = population) %>%
        
        rbind(gene_markers$immune)
      
    }else{
      
      deconv_markers <- user_data$refined_neoplastic %>% 
        
        tidyr::drop_na() %>%
        
        rename("HUGO symbols" = marker,
               "Cell population" = population) %>%
        
        rbind(gene_markers$immune)
      
    }
    
     user_data$deconv_markers <- deconv_markers
     
     return(deconv_markers)
    
    })
  
  
  # Render the Deconvolution markers
  output$deconv_markers <- DT::renderDataTable({
    
    validate(
      
      need(!is.null(input$upload_file),"Please upload a dataset to view"),
    
    )
    
    datatable(get_markers(),
              rownames = FALSE, 
              extensions = c("FixedColumns", 'Buttons'),
              options = list(scrollX = TRUE, 
                             scrollY = 300,
                             # paging = FALSE,
                             pageLength = 20,
                             scrollCollapse = TRUE, 
                             orderClasses = TRUE, 
                             autoWidth = FALSE,
                             search = list(regex = TRUE)
              )
    )
  }, server = TRUE)
  
  
# DECONVOLUTION SCORES ---------------------------------------------------------
  
  scores  <-  reactive({
    
    tinyscalop::MCPCounter_score(x = user_data$exprs, 
                                 gene_pops = user_data$deconv_markers, 
                                 out_digits = 2)})
  
  # Render the Deconvolution scores
  output$deconv_scores <- DT::renderDataTable({
    
    validate(
      
      need(!is.null(input$upload_file),"Please upload a dataset to view"),
      
      need(input$deconvolute_button >=1,'Please press "Run" to view')
      
    )
    
    
    datatable(scores(),
              rownames = FALSE, 
              extensions = c("FixedColumns", 'Buttons'),
              options = list(scrollX = TRUE, 
                             scrollY = 300,
                             # paging = FALSE,
                             pageLength = 20,
                             scrollCollapse = TRUE, 
                             orderClasses = TRUE, 
                             autoWidth = FALSE,
                             search = list(regex = TRUE)
              )
    )
  }, server = TRUE)
  
  
})
