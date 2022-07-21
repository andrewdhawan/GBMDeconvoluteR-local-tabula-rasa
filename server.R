# This script contains the server logic for the GBMDeconvoluteR Shiny web application. 
# You can run the application by clicking 'Run App' above.

library(shiny)
library(rsconnect)
library(MCPcounter)
library(tidyverse)
library(openxlsx)
# library(scalop)
library(glue)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  options(shiny.maxRequestSize=200*1024^2)

  #' Reactivity required to display download button after file upload
  output$finishedUploading <- reactive({
    if (is.null(input$upFile))
    { 0 } else { 1 }
  })
  
  outputOptions(output, 'finishedUploading', suspendWhenHidden=FALSE)
  
  
  #' Reactive function to generate Deconvolute scores to pass to data table
  deconv_call <- eventReactive(input$goDec, {
    
    inFile <- input$upFile
    
    if(tools::file_ext(inFile$name) %in% "xlsx"){
      
      upData <- openxlsx::read.xlsx(inFile$datapath,
                                    colNames = TRUE)
    } else{
      
      upData <- readr::read_delim(file = inFile$datapath,
                                  col_types = cols(),
                                  delim = input$sep, 
                                  quote=input$quote)
    }
    
    # upData <- readr::read_delim(file = "data/test_data/test.csv",
    #                             col_types = cols(),
    #                             delim = ",", 
    #                             quote="")
    # 
    
    MCPCounter_score <- function(x, feat_types = c("HUGO_symbols","ENTREZ_ID"),
                                 gene_pops = genes){
      
      if(!any(class(x) %in% c("tbl_df", "tbl", "data.frame"))) stop("MCPCounter input is not a data.frame", call. = FALSE)
      
      if(!any(grepl("^gene$", colnames(x), ignore.case = T))) stop("Gene column not found in input data", call. = FALSE)
      
      feature_types <- match.arg(feat_types, choices = c("HUGO_symbols","ENTREZ_ID"),
                                 several.ok = FALSE)
      
      score_data <- as.data.frame(x)
      
      gene_index <- grep("^gene$", colnames(score_data), ignore.case = T)
      
      rownames(score_data) <- score_data[[gene_index]]
      
      score_data <- score_data[,-gene_index]
      
      mcp_deconvolute <- MCPcounter::MCPcounter.estimate(score_data,
                                                         featuresType = feature_types,
                                                         genes = gene_pops)
      
      mcp_deconvolute <- as.data.frame(t(mcp_deconvolute))
      
      mcp_deconvolute <- tibble::rownames_to_column(mcp_deconvolute, 
                                                    var = "Mixture")
      
      return(mcp_deconvolute)
      
    }
    
    
    scores  <- MCPCounter_score(upData, gene_pops = gene_set_list)
      
    # upData <- read.csv(inFile$datapath, 
    #                    header=input$header, 
    #                    sep=input$sep, 
    #                    quote=input$quote, 
    #                    stringsAsFactors=FALSE)
    # 
    # row.names(upData) <- upData[,"Sample"]
    # exprs <- data.frame(t(upData[,-1]),check.names=FALSE)
    # platformDec <- ifelse(input$platformDec == "rnaseq",TRUE, FALSE)
    
    # gene_list <- switch(input$geneListDec,
    #                     "Charoentong et al. 2017" = gene_set_list$charoentong,
    #                     "Newman et al. 2015" = gene_set_list$LM22,
    #                     "Engler et al. 2012" = gene_set_list$engler,
    #                     "Bindea et al. 2013" = gene_set_list$galon,
    #                     "MSigDB gene sets" = gene_set_list$msigdb[input$genesets_msigdb])
    # 
    # set.seed(1234)
    # gsva_results <- GSVA::gsva(expr=as.matrix(exprs), gset.idx.list = gene_list, method="ssgsea", rnaseq = platformDec, parallel.sz = 0,
    #                            min.sz = input$min.sz, max.sz= input$max.sz, verbose= FALSE)
    # deconv_scores <- data.frame(Sample = rownames(upData),t(gsva_results))
    # deconv <- list(results = gsva_results, scores = deconv_scores)
  })
  
  
  #' Rerndering the Deconvolute scores as a data table
  output$deconvScore <- DT::renderDataTable({
    validate(
      need(!is.null(input$upFile),"Please Upload a Dataset to retrive scores"),
        need(!is.null(input$goDec),'Please press "RUN DECONVOLUTE"')
    )
    datatable(deconv_call(), rownames = FALSE, extensions = c("FixedColumns", 'Buttons'),
              options = list(scrollX = TRUE, scrollCollapse = TRUE, orderClasses = TRUE, autoWidth = TRUE)
    )
  },server = FALSE)
  
  
  
})
