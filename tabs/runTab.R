# UI-elements for the Run page
# this page consists of a tab panel where the options are set on a sidebar panel
# which will be on the left side of the page and then the results will be displayed
# on a main tabbed panel on the right hand side of the page.

tabPanel(
  
  title = "Run", icon = icon("running", lib = "font-awesome"),
  
  tagList(tags$head(includeCSS("www/styles.css"))),
  
  
  sidebarLayout(
    
    fluid = FALSE,
    
    # SIDEBAR PANEL START ----
    
    sidebarPanel = sidebarPanel(
      
      br(), 
     
      # UPLOAD DATA WELL PANEL 
      wellPanel(
        
        tags$h4("Upload Data"),
        
        helpModal(modal_title ="Uploading Data",
                  link = "helpupload", 
                  help_file = includeMarkdown("tools/help/help_uploading.Rmd")
                  ),
        br(),
        
        fileInput(inputId = "upload_file", 
                  multiple = FALSE,
                  label = "",
                  buttonLabel = "Browse...",
                  accept=c(".csv", ".tsv", ".xlsx"))
        
      ),
      
      br(), 
      
      # RUN DECONVOLUTION WELL PANEL
      wellPanel(
        
        tags$h4("Deconvolution"),
        
        helpModal(modal_title ="Deconvolution Options",
                  link = "helptumourintrinsic",
                  help_file = includeMarkdown("tools/help/help_tumour_intrinsic.Rmd")),
        
        br(), br(),
        
        radioButtons(inputId = "tumour_intrinsic",
                     label = strong("Tumour Intrinsic Genes Only:"),
                     choices = c("Yes" = TRUE,
                                 "No" = FALSE),
                     inline = TRUE),
        
        br(),
        
        # RUN DECONVOLUTION BUTTON
        conditionalPanel(
          
          condition = "output.finishedUploading",
          
          actionButton(inputId = "deconvolute_button",
                       label = "Run",
                       class= "btn-success")
          )
        ),
    ),
    
    # SIDEBAR PANEL END ----

    # MAIN PANEL UI START ----
    
    mainPanel(
      
      tabsetPanel(
        id = "main_runpage_panel",
        # File upload
        tabPanel(title = "Uploaded Data",
                 id = "uploaded_tab",
                 DT::dataTableOutput(outputId = "uploaded_data")
        ),
        
        # Markers
        tabPanel(title = "Markers", 
                 id = "marker_tab",
                 DT::dataTableOutput(outputId = "deconv_markers")
        ),
        
        # Scores 
        tabPanel(title = "Scores", 
                 id = "scores_tab",
                 DT::dataTableOutput(outputId = "deconv_scores")
        ),
        
        # Barplot
        tabPanel(title = "Barchart", 
                 id = "barplot_tab",
                 plotOutput(outputId = "deconvBoxPlot", 
                            height = "100%")
        )
      )
    )
    
    # MAIN PANEL UI END ----
  
  )
)

