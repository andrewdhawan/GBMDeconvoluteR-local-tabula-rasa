# This script contains the server logic for the GBMDeconvoluteR Shiny web application. 
# You can run the application by clicking 'Run App' above.


shinyServer(function(input, output, session) {
# SESSION INFO -----------------------------------------------------------------  
  
  output$sessionInfo <- renderPrint({
    capture.output(sessionInfo())
  })  
  
# HELP MODALS  -----------------------------------------------------------------  

  # File Uploads
  observeEvent(input$upload_help, {
    
    showModal(
      
      modalDialog( title = "File Uploads",
                   includeMarkdown("tabs/Run/help/help_uploading.Rmd"),
                   footer = NULL,
                   easyClose = TRUE, 
                   fade = TRUE)
    )
  })  
  
  # Marker Gene List
  observeEvent(input$marker_genelist_help, {
    
    showModal(
      
      modalDialog( title = "Marker Gene List Selection",
                   includeMarkdown("tabs/Run/help/help_marker_genelist.Rmd"),
                   footer = NULL,
                   easyClose = TRUE, 
                   fade = TRUE)
    )
  })  
  
  # Tumour Intrinsic Genes
  observeEvent(input$TI_genes_help, {
  
    showModal(
      
      modalDialog( title = "Tumour Intrinsic Genes",
                   includeMarkdown("tabs/Run/help/help_tumour_intrinsic.Rmd"),
                   footer = NULL,
                   easyClose = TRUE, 
                   fade = TRUE)
      )
  })  
  
# DYNAMIC RUN BUTTON -----------------------------------------------------------
  
  # This feature is no longer used in the shiny app
  
  # Reactivity required to display the Run button after upload
  output$finishedUploading <- reactive({

    if (is.null(input$upload_file)) 0 else 1

  })

  outputOptions(output, 'finishedUploading', suspendWhenHidden=FALSE)


# USER UPLOADED DATA -----------------------------------------------------------
 
  data <- reactive({
    
    validate(
      need(!is.null(input$upload_file),"Please upload a dataset to view")
      )
    
    load_user_data(name = input$upload_file$name,
                   path = input$upload_file$datapath)

  })

  input_check <- reactive({

    check_user_data(data())

  })

  observeEvent(!is.null(data()),{
    
    input_check <- check_user_data(data())
    
    if(!is.null(input_check)){
      
      showModal(modalDialog(
        # title = "FILE UPLOAD ERROR!",
        tags$br(),
        tags$image(src = "error.svg", 
                   style = "width: 30%; display: block; margin-left: auto; margin-right: auto;"),
        tags$br(),
        tags$text(input_check, 
        style = "color: gray; font-size: 30px;font-variant-caps: all-small-caps;
                 font-weight: 900;display: flex; width: 100%; justify-content: center;
                 align-content: center;"),
        footer = NULL,
        easyClose = TRUE,
        fade = TRUE
        ))
    }
    
    
  }, priority = 1, ignoreNULL = FALSE, once = FALSE)
    
  
  output$uploaded_data <- DT::renderDataTable({
  
    req(is.null(input_check()))
    
    datatable(data(), 
              rownames = FALSE )
    
  }, server = TRUE)
  
 
# DECONVOLUTION MARKERS -------------------------------------------------------

  cleaned_data <- reactive({ 
    
    req(is.null(input_check()))
    
    preprocess_data(data())
  
    })
    
  get_markers <- reactive({
    
    req(cleaned_data(), cancelOutput = TRUE)

    
   selected_markers <- switch(input$markergenelist,
           
           `Ajaib et.al (2022)` = {
             
             list(neoplastic_markers = gene_markers$neftel2019_neoplastic,
                  immune_markers = gene_markers$ajaib2022_immune)
             
             },
           
           `Ruiz-Moreno et.al (2022)` ={
             
             list(neoplastic_markers = gene_markers$moreno2022_neoplastic,
                  immune_markers = gene_markers$moreno2022_immune)
           })
    
   
   if(input$tumour_intrinsic){
     
     deconv_markers(exprs_matrix = cleaned_data(),
                    neftel_sigs = selected_markers$neoplastic_markers,
                    TI_genes_only = TRUE,
                    TI_markers = gene_markers$wang2017_tumor_intrinsic,
                    immune_markers =  selected_markers$immune_markers
     )
     
   }else{
     
     deconv_markers(exprs_matrix = cleaned_data(),
                    neftel_sigs = selected_markers$neoplastic_markers,
                    immune_markers =  selected_markers$immune_markers)
   }
   
   
    # if(input$tumour_intrinsic){
    #   
    #   deconv_markers(exprs_matrix = cleaned_data(),
    #                  neftel_sigs = gene_markers$neftel2019_neoplastic,
    #                  TI_genes_only = TRUE,
    #                  TI_markers = gene_markers$wang2017_tumor_intrinsic,
    #                  immune_markers =  gene_markers$ajaib2022_immune
    #                  )
    #   
    #   }else{
    #   
    #   deconv_markers(exprs_matrix = cleaned_data(),
    #                  neftel_sigs = gene_markers$neftel2019_neoplastic,
    #                  immune_markers =  gene_markers$ajaib2022_immune)
    #   }
    
  })
  
  output$deconv_markers <- DT::renderDataTable({
    
    datatable(get_markers(),
              rownames = FALSE, 
              extensions = c("FixedColumns", 'Buttons')
              )
    
  }, server = TRUE)
  
# DECONVOLUTION SCORES ---------------------------------------------------------
  
  scores  <-  reactive({
    
    req(get_markers(), cancelOutput = TRUE)
    
    score_data(exprs_data = cleaned_data(),
               markers = get_markers(),
               out_digits = 2)
    }) 
    
  output$deconv_scores <- DT::renderDataTable({
    
    datatable(scores(),
              rownames = FALSE, 
              extensions = c("FixedColumns", 'Buttons')
              )
    
  }, server = TRUE)
  
# PLOT SCORES ------------------------------------------------------------------
  
  plot_output <- reactive({
    
    req(scores())
    
    switch(input$markergenelist,
           
           `Ajaib et.al (2022)` = plot_scores(scores = scores(),
                                              plot_order = plot_order$ajaib_et_al_2022),
           
           `Ruiz-Moreno et.al (2022)` = plot_scores(scores = scores(),
                                                   plot_order = plot_order$moreno_et_al_2022)
             )

  })
  
  # Dynamically scale the width of the bar plot
  scale_plot_width <- reactive({

    if(nrow(scores()) > 2){
      
      scaling_factor <- nrow(scores()) * 50
      
      return( 400 + scaling_factor)
      
    } else return(400)
  
  })
  
  
  scale_plot_height <- reactive({
    
    switch(input$markergenelist,
           
           `Ajaib et.al (2022)` = 2500,
           
           `Ruiz-Moreno et.al (2022)` = 4000
    )
    
    
  })
  

  output$scores_plot <- renderPlot(plot_output(), 
                                   width = scale_plot_width, 
                                   height = scale_plot_height
                                   ) 
# DOWNLOAD PLOT ---------------------------------------------------------------  
  
  output$filetype_select <- renderUI({

    req(!is.null(input$upload_file))

    selectInput(inputId = "file_format", 
                label = NULL,
                choices=c("pdf","svg","png","tiff","ps"),
                selected = "pdf")

  })
  
  output$download_button <- renderUI({

    req(!is.null(input$upload_file))

    downloadButton(outputId = "downloadData", label =  'Download Plot')

  })


  # Generate the file name dynamically with appropriate extension
  fn_downloadname <- reactive({
    
    paste0(format(Sys.time(), "%d-%m-%Y %H-%M-%S"),
           "_GBMDeconvoluteR_plot.", input$file_format) 
    
  })
  
  
  output$downloadData <- downloadHandler(
    
    filename = function(){
      
      fn_downloadname()
    
    },
      
    content = function(file) {
    
      # Dynamically set plot width 
      plot_width <- function(min_width = 6, sample_scaling= 0.5){
        
        if(nrow(scores()) > 3){
          
          scaling_factor <- nrow(scores()) * sample_scaling
          
          return( min_width * 1 + scaling_factor)
          
        } else return(min_width)
        
      }
      
      # Dynamically set plot width 
      plot_height <- function(){
        
        switch(input$markergenelist,
               
               `Ajaib et.al (2022)` = 30,
               
               `Ruiz-Moreno et.al (2022)` = 45
        )
        
      }
      
      
      if(tools::file_ext(fn_downloadname()) == "ps"){
        
        ggsave(file, 
               plot = plot_output(), 
               width = plot_width(),
               device =  grDevices::cairo_ps,
               height = plot_height(),
               units = "in", 
               limitsize = FALSE)
        
        
      }else{
        
        ggsave(file, 
               plot = plot_output(), 
               width = plot_width(), 
               height = plot_height(),
               units = "in", 
               limitsize = FALSE)
        
        
      }
      
      
    
      
    }
  
    )
  
  
})
